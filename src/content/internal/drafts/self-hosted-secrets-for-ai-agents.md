---
title: 'Self-Hosted Secrets Management for AI Agents with Infisical'
description: 'How I set up Infisical on my home NAS to manage secrets for shell scripts, React apps, and AI agent runtimes — so API keys never touch disk or leave my network.'
pubDate: 'Mar 24 2026'
heroImage: 'https://images.unsplash.com/photo-1768720407298-1b24a0f6749d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3MzE0MDd8MHwxfHNlYXJjaHwzfHx2YXVsdCUyMHNlY3VyaXR5fGVufDB8MHx8fDE3NzQzMzI0OTl8MA&ixlib=rb-4.1.0&q=80&w=1080'
tags: ["security", "devops", "secrets-management", "ai-agents", "self-hosted"]
---

I spent last weekend doing something I should have done a year ago: ripping every API key, token, and password out of `.env` files scattered across my machines and putting them into a proper secrets manager. Not AWS Secrets Manager. Not HashiCorp Vault. [Infisical](https://infisical.com) — open source, self-hosted, running on my Unraid NAS in a Docker container.

Here's what I learned, and why I think this setup is especially important if you're running AI agents.

## Why Zero Trust Matters (Even on Your Home Network)

Zero trust architecture is one of those phrases that sounds like enterprise marketing until you actually think about what it means. The core idea is simple: **no implicit trust based on network location**. Just because a device is on your LAN doesn't mean it should have access to your production database credentials.

Traditional perimeter security says "everything inside the firewall is safe." Zero trust says "prove who you are every time, regardless of where you are." In practice, that means:

- **Identity verification at every layer** — not just at the front door
- **Least-privilege access** — services get only the secrets they need
- **No long-lived credentials on disk** — secrets are injected at runtime and exist only in memory
- **Audit logging** — every secret access is recorded

This matters more than ever now that we're handing API keys to AI agents. When you run `claude` with access to `$OPENAI_API_KEY` or `$STRIPE_SECRET_KEY`, you need to think carefully about where those values live, how they get there, and who (or what) can see them.

A `.env` file sitting in your project directory is the opposite of zero trust. It's a plaintext file that any process, any agent, any compromised npm package can read. It gets accidentally committed to git. It gets copied to backup drives. It persists on disk long after you've rotated the key.

## The Setup: Infisical on Unraid

Infisical is an open-source secrets management platform. Think of it as "HashiCorp Vault but you can actually set it up in an afternoon." It gives you a web UI for managing secrets, a CLI for injecting them at runtime, and an API for machine-to-machine access.

Here's my setup:

- **Infisical** runs as a Docker container on my Unraid NAS
- **Cloudflare Tunnel** exposes it at `secrets.byte-sized.io` (no port forwarding needed)
- **Cloudflare Zero Trust** protects the web UI with email OTP — you can't even see the login page without passing a Cloudflare Access challenge
- **Rate limiting** on auth endpoints: 10 attempts per minute, then a 1-hour ban
- **VLAN firewall rules** restrict which network segments can reach the Infisical container at all

That last point is the zero trust part in action. My IoT devices can't reach the secrets manager. My guest network can't reach it. Only my development VLAN and my server VLAN have routes to the container. Even if someone compromises a smart bulb, they can't pivot to my secrets.

The Docker Compose is straightforward — Infisical provides an official `docker-compose.yml` that includes Postgres and Redis. On Unraid, I run it via the Docker Compose Manager plugin. The only custom pieces are the Cloudflare tunnel sidecar and the environment variables for the Infisical instance itself (encryption keys, database URL, etc.).

## Pattern 1: Shell Scripts

The simplest use case. You have a shell script that needs an API key.

**Before (the bad way):**

```bash
#!/bin/bash
# deploy.sh
source .env  # API_KEY is now in plaintext on disk
curl -H "Authorization: Bearer $API_KEY" https://api.example.com/deploy
```

**After (with Infisical):**

```bash
# No .env file anywhere. Secrets injected at runtime.
infisical run --env=prod --path=/deploy -- ./deploy.sh
```

Inside `deploy.sh`, you just reference `$API_KEY` like normal. Infisical fetches the secret from the server, injects it as an environment variable, runs your script, and when the process exits, the secret is gone. It never touched the filesystem.

You can scope secrets by environment (`dev`, `staging`, `prod`) and by path (folder structure within Infisical). A deploy script gets `/deploy` secrets. A monitoring script gets `/monitoring` secrets. Least privilege.

```bash
# Different scripts get different secret scopes
infisical run --env=prod --path=/deploy    -- ./deploy.sh
infisical run --env=prod --path=/monitoring -- ./health-check.sh
infisical run --env=dev  --path=/testing    -- ./run-tests.sh
```

For authentication, the CLI uses `infisical login` for interactive sessions (browser-based OAuth or email/password). For cron jobs and automation, you create a **service token** — a long-lived credential scoped to a specific project and environment. The service token is the *one* secret you store on disk (as an environment variable in the cron job's environment), and it unlocks everything else.

```bash
# Cron job using a service token
INFISICAL_TOKEN="st.xxxx.yyyy" infisical run --env=prod --path=/backups -- ./backup.sh
```

## Pattern 2: React Apps (Vite)

Frontend apps have a specific pattern with secrets because the values get baked into the bundle at build time. With Vite, any environment variable prefixed with `VITE_` is exposed to your client-side code.

**Before:**

```bash
# .env.local (checked into git by someone on the team, inevitably)
VITE_API_URL=https://api.example.com
VITE_POSTHOG_KEY=phc_xxxxxxxxxxxx
VITE_STRIPE_PUBLISHABLE_KEY=pk_live_xxxxxxxxxx
```

**After:**

```bash
# Development
infisical run --env=dev --path=/frontend -- npm run dev

# Production build
infisical run --env=prod --path=/frontend -- npm run build
```

In Infisical, you store your secrets with the `VITE_` prefix:

```
VITE_API_URL        = https://api.example.com
VITE_POSTHOG_KEY    = phc_xxxxxxxxxxxx
VITE_STRIPE_KEY     = pk_live_xxxxxxxxxx
```

Vite picks them up from the environment automatically. Your `.env` files disappear. Your CI/CD pipeline uses a service token to pull secrets at build time:

```yaml
# GitHub Actions example
- name: Build
  env:
    INFISICAL_TOKEN: ${{ secrets.INFISICAL_SERVICE_TOKEN }}
  run: infisical run --env=prod --path=/frontend -- npm run build
```

The beauty here is that your publishable keys (Stripe `pk_live_`, PostHog project keys) aren't really "secrets" — they're meant to be in the client bundle. But managing them through Infisical means you have one source of truth, environment-specific overrides, and an audit trail of who changed what and when. No more "which `.env.local` has the right PostHog key?" conversations in Slack.

## Pattern 3: AI Agents with Claude Code

This is where things get interesting, and honestly, this is the use case that pushed me to set up Infisical in the first place.

When you run Claude Code, it executes in your terminal and inherits your shell environment. If you have `$OPENAI_API_KEY` in your `.zshrc`, Claude can see it. If you have `$STRIPE_SECRET_KEY` in a `.env` file and your code reads it, Claude can read that file too.

Here's the thing most people don't think about: **environment variables are available to Claude Code, but they are NOT sent to Anthropic's servers.** The LLM receives the conversation context — your messages, file contents, tool outputs. It doesn't receive a dump of your `env`. When Claude runs a command that references `$MY_SECRET`, the shell resolves the variable locally. The actual value stays on your machine.

But `.env` files? Those *are* files. Claude can read files. If it reads your `.env` to understand your project, those values are now in the conversation context, which means they're sent to the API.

`infisical run` fixes this completely:

```bash
# Claude Code gets access to secrets via $ENV without them ever being in a file
infisical run --env=dev --path=/claude-tools -- claude
```

Now Claude's process has `$GITHUB_TOKEN`, `$OPENAI_API_KEY`, `$DATABASE_URL`, whatever it needs — all as environment variables. When Claude runs a script that references `$GITHUB_TOKEN`, the shell resolves it locally. The token value is never in a file, so Claude never reads it into context, and it never gets sent to Anthropic.

Here's my actual wrapper script:

```bash
#!/bin/bash
# claude-with-secrets.sh

PROJECT="${1:-default}"

infisical run \
  --env=dev \
  --path="/agents/$PROJECT" \
  -- claude
```

Different projects get different secret scopes:

```bash
# Working on the blog — gets CMS and deploy keys
./claude-with-secrets.sh blog

# Working on the SaaS app — gets Stripe, Supabase, Resend keys
./claude-with-secrets.sh clawboard

# Working on infrastructure — gets Cloudflare, Tailscale keys
./claude-with-secrets.sh infra
```

Each scope in Infisical contains only the secrets that project needs. The blog project can't access Stripe keys. The infrastructure project can't access the database. Least privilege, enforced at the secrets manager level.

### What Claude Sees vs. What It Doesn't

To be very explicit about the security boundary here:

| What Claude Code CAN access | What Claude Code CANNOT access |
|---|---|
| `$ENV_VAR` values when running commands | The Infisical service token itself (if stored properly) |
| Output of commands that print env vars | Other project scopes in Infisical |
| Files in the working directory | Secrets from other environments (prod vs. dev) |

| What gets sent to Anthropic | What stays local |
|---|---|
| File contents Claude reads | Environment variable values |
| Command output Claude captures | Secrets resolved by the shell |
| Your conversation messages | The Infisical authentication layer |

The key insight: `infisical run -- claude` creates a clean process boundary. Secrets exist as environment variables in the shell process tree. The LLM interacts with those secrets only through tool use (running commands), and the actual secret values never enter the conversation context unless a command explicitly prints them. You can even add a `.claude/settings.json` rule to deny commands like `env` or `printenv` if you want extra paranoia.

## Pattern 4: OpenClaw (and Any Agent Runtime)

[OpenClaw](https://github.com/byte-sized-oss/openclaw) is an open-source agent runtime that I've been building. It runs agents as containerized processes with well-defined input/output contracts. The same `infisical run` pattern applies here — in fact, it's even cleaner because OpenClaw agents are designed to receive configuration through environment variables.

```bash
# Run an OpenClaw agent with injected secrets
infisical run --env=prod --path=/openclaw/researcher -- \
  openclaw run researcher --task "Analyze competitor pricing"
```

The agent process inherits the secrets it needs: API keys for LLM providers, database credentials for storing results, webhook URLs for notifications. The agent code references `process.env.OPENAI_API_KEY` or `$ANTHROPIC_API_KEY` — it doesn't know or care that Infisical put them there.

For agent-to-agent workflows where one agent spawns another, each agent can have its own secret scope:

```bash
# Orchestrator agent — gets broad access
infisical run --env=prod --path=/openclaw/orchestrator -- \
  openclaw run orchestrator --workflow=research-pipeline

# Inside the orchestrator, when it spawns child agents:
# Each child gets its own scoped secrets via Infisical service tokens
```

This pattern works with any agent runtime — LangChain, CrewAI, AutoGen, whatever comes next. The runtime doesn't need to integrate with Infisical at all. You just wrap the launch command:

```bash
# LangChain agent
infisical run --env=prod --path=/langchain -- python agent.py

# CrewAI
infisical run --env=prod --path=/crewai -- python crew.py

# Any Docker-based agent
infisical run --env=prod --path=/agents -- docker run my-agent
```

The value proposition is the same every time: secrets are injected at the process level, never written to disk, scoped to the minimum required set, and audited through Infisical's access logs. You can rotate a key in Infisical's UI and every agent picks it up on next launch. No redeployment, no config file editing, no "which server still has the old key?"

## Why Infisical Over the Big Names?

I evaluated three options: AWS Secrets Manager, HashiCorp Vault, and Infisical. Here's why I went with Infisical.

### AWS Secrets Manager

AWS Secrets Manager is fine if you're already all-in on AWS. It costs $0.40/secret/month plus $0.05 per 10,000 API calls. For a home lab with 50+ secrets accessed frequently by agents and dev tools, that adds up. More importantly:

- **Vendor lock-in.** Your secrets are in AWS. Your access patterns depend on IAM roles. Moving to another provider means migrating everything.
- **No self-hosting.** Your secrets live on someone else's servers. For API keys that control billing (OpenAI, Anthropic, Stripe), I want those on hardware I control.
- **Complexity.** IAM policies for secrets access are a whole certification's worth of knowledge. I don't need ABAC policies and cross-account resource sharing. I need "this script gets these three keys."

### HashiCorp Vault

Vault is the gold standard for enterprise secrets management. It's also wildly overengineered for a home lab or small team:

- **Operational complexity.** Vault requires unsealing after every restart. You need to manage unseal keys, set up auto-unseal with a KMS, or accept that your secrets are unavailable after a NAS reboot until you manually intervene.
- **Resource hungry.** Vault wants a real cluster. Running it as a single Docker container works, but you're fighting the architecture.
- **Learning curve.** Vault's policy language, auth methods, and secret engines are powerful but require serious investment to learn. I spent a weekend on Vault tutorials and still wasn't confident in my setup.

### Infisical

Infisical hits the sweet spot:

- **Actually open source.** MIT licensed. The full platform, not an "open core" bait-and-switch. You can self-host everything with zero license fees.
- **Simple to operate.** Docker Compose up, create a project, start storing secrets. No unsealing ceremony. No policy language to learn. The web UI is genuinely good.
- **Great CLI.** `infisical run` is the killer feature. It's the entire workflow: authenticate, fetch secrets, inject as env vars, run your command, clean up. One line.
- **Sensible auth.** Email/password, Google OAuth, GitHub OAuth, SAML — all built in. Service tokens for machines. No separate auth backend to configure.
- **E2E encryption.** Secrets are encrypted client-side before being stored. Even if someone compromises the database, they get ciphertext.
- **Active development.** The project ships features weekly. Kubernetes operator, Terraform provider, native integrations — it's moving fast and the community is healthy.

The cost comparison is simple: Infisical self-hosted is free. AWS Secrets Manager would cost me roughly $20/month for my usage. Vault is free but would cost me weekends in operational toil. My Unraid NAS is already running 24/7 — adding one more Docker container costs nothing.

## The Defense-in-Depth Stack

Here's my full security stack for secrets access, from outermost layer to innermost:

```
1. Cloudflare Zero Trust (email OTP)      — blocks unauthorized users from the UI
2. Cloudflare Tunnel                       — no ports exposed to the internet
3. VLAN firewall rules                     — only dev/server VLANs can reach Infisical
4. Rate limiting (10/min → 1hr ban)        — brute force protection on auth
5. Infisical auth (email + password)       — application-level authentication
6. Project/environment scoping             — least privilege per use case
7. Service tokens (machine access)         — scoped, rotatable, audited
8. E2E encryption                          — secrets encrypted at rest
9. Runtime injection only                  — secrets never written to disk
```

Nine layers. Any single layer can fail and the others still protect you. That's what defense in depth actually looks like — not one big wall, but concentric rings that each independently limit blast radius.

## Getting Started

If you want to set this up yourself:

1. **Deploy Infisical.** Use the [official Docker Compose](https://infisical.com/docs/self-hosting/deployment-options/docker-compose). It takes about 15 minutes on any Linux box.

2. **Set up a tunnel.** Cloudflare Tunnel (free tier) gives you HTTPS access without opening ports. Point it at your Infisical container's port.

3. **Add Zero Trust.** In Cloudflare's dashboard, create an Access policy requiring email OTP for your Infisical subdomain. Takes 5 minutes.

4. **Install the CLI.** `brew install infisical/get-cli/infisical` on macOS, or `curl` the binary on Linux.

5. **Migrate your `.env` files.** Go through each project, create a corresponding project/environment in Infisical, import the secrets, and delete the `.env` file.

6. **Update your workflows.** Replace `source .env && ./script.sh` with `infisical run -- ./script.sh`. Replace `npm start` with `infisical run -- npm start`.

7. **Create service tokens** for CI/CD and automated workflows.

The whole migration took me about 3 hours across a dozen projects. The hardest part was finding all the `.env` files — they were everywhere. `find ~/ -name '.env' -not -path '*/node_modules/*'` was a humbling command to run.

## Closing Thoughts

We're entering an era where AI agents need access to real credentials — API keys, database connections, deployment tokens. The old approach of "stick it in a `.env` file and add it to `.gitignore`" doesn't scale when you have agents that can read files, execute commands, and operate semi-autonomously.

Self-hosted secrets management isn't paranoia. It's basic hygiene. Infisical makes it practical enough that there's no excuse not to do it. The `infisical run` pattern is simple, universal, and secure. It works for shell scripts, web apps, AI agents, and anything else that reads environment variables — which is everything.

Your secrets are the keys to your kingdom. Keep them off disk, keep them scoped, keep them on hardware you control, and for the love of all that is holy, stop committing `.env` files to git.
