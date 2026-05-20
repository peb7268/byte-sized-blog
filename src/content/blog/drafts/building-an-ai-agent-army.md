---
title: 'I Built an Army of AI Agents That Talk to Each Other'
description: 'How I set up 50+ AI agents across two runtimes that delegate tasks, chain workflows, and communicate through Discord — all from my couch.'
pubDate: 'Mar 22 2026'
heroImage: 'https://images.unsplash.com/photo-1495055154266-57bbdeada43e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3MzE0MDd8MHwxfHNlYXJjaHwzfHxhaSUyMGF1dG9tYXRpb24lMjByb2JvdCUyMGZ1dHVyaXN0aWN8ZW58MHwwfHx8MTc3NDE1OTMxMnww&ixlib=rb-4.1.0&q=80&w=1080'
draft: false
---

What started as "I should centralize my Claude Code agents" turned into a full multi-runtime agentic system with 50+ agents, a bridge protocol, and a menu bar app. In one evening.

## The Problem

I had agents scattered everywhere. Claude Code agents in `.claude/agents/` across 10 different project directories. Some duplicated. Some outdated. No way to share them. And my OpenClaw instance on the cloud couldn't talk to my local Claude Code at all.

## The Solution: AGENT_VAULT

I created a centralized vault — a single Git repo that holds every agent definition, skill, command, and workflow. The key insight: agents are just markdown files. They can be symlinked, versioned, and shared like any code.

```
AGENT_VAULT/
├── anthropic/agents/     # 51 Claude Code agents
├── anthropic/skills/     # 17 skill packs + 52 commands
├── anthropic/workflows/  # MHM design pipeline, CI/CD
├── openclaw/             # 4 OpenClaw agents
├── bridge/               # Cross-runtime communication
├── manifest.json         # Dependency graph + bundles
└── docs/                 # PRDs, protocols, guides
```

## The Bridge: Making Two AIs Talk

The real magic is the bridge. I have Claude Code running on my MacBook (codename: RCC) and OpenClaw running on an Alibaba Cloud server (codename: ClawControl). They needed to communicate.

The solution uses two channels:
1. **Git-based task files** — JSON files in `tasks/` that get synced every 2 minutes via launchd
2. **Discord messages** — structured `[AGENT_MSG]` messages for real-time alerts

When RCC needs cloud compute, it creates a task file and posts to Discord. ClawControl picks it up, does the work, and responds. And vice versa.

### Task Chaining

The best part: agents can chain tasks. A → B → C, where each step's output feeds the next:

```bash
./bridge.sh chain '[
  {"agent": "rcc", "content": "Research competitors"},
  {"agent": "clawcontrol", "content": "Summarize findings"},
  {"agent": "rcc", "content": "Write blog post from summary"}
]'
```

Each step auto-advances when the previous one completes. The chain just flows.

## The Monitoring Layer

I didn't want to manually check for tasks. So I built a 3-tier monitoring system:

1. **Primary:** A cron job polls every 5 minutes
2. **Secondary:** A session-start hook checks on every new Claude Code session
3. **Fallback:** Cronitor — a Tauri menu bar app I built that watches the task directory every 30 seconds and sends macOS notifications

Yes, I built a native Mac app to monitor my AI agents. In one session. With Tauri + Svelte + Rust. It shows my cron jobs, launchd agents, and bridge task status all in one place.

## What I Learned

1. **Agents are just files.** Treat them like code — version, lint, share, symlink.
2. **Git is a great message bus.** For non-real-time communication, task files in a synced repo work surprisingly well.
3. **Discord is the glue.** Both humans and agents can read it. It's the universal notification layer.
4. **Build the monitoring first.** I wasted time debugging silent failures before adding the 3-tier polling system.
5. **Don't over-architect the protocol.** Start with JSON files and `[AGENT_MSG]` format. Add complexity only when needed.

## The Numbers

- **51 Claude Code agents** across 7 categories
- **4 OpenClaw agents** on the cloud
- **17 skill packs** + 52 slash commands
- **12 Discord channels** for agent communication
- **10/10 bridge protocol tests passed** (bidirectional, concurrent, dedup, failure recovery)
- **1 Tauri menu bar app** built and running
- **1 secrets manager** (Infisical) deployed on my NAS
- **0 lines of code** copied between projects — everything is symlinked from the vault

## What's Next

- Promoting Izzy (my triage agent) to executive assistant — one agent to rule them all
- Adding Rosetta translation so agents work across Claude, OpenAI, Gemini, and OpenClaw
- Building a proper dashboard for agent health and task history

The full system is open for anyone to adapt. The pattern is simple: centralize your agents, give them a way to talk, and monitor the conversation.

---

*This post was drafted by Scribble, my blog writer agent, who pulled the hero image from Unsplash automatically. Iterate daily. Ship fast.*
