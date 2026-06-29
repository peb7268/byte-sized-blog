---
title: 'Your AI Doesn''t Know You: The Case for a Personal Context Management System'
series: 'PCMS'
seriesOrder: 1
description: 'LLMs are powerful but context-blind by default. A PCMS — your notes, daily logs, and projects, structured so an AI can read them — is the real leverage in an AI-first world.'
pubDate: 'May 20 2026'
heroImage: 'https://images.unsplash.com/photo-1732704573802-8ec393009148?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080&q=80'
tags: ["pcms", "context-engineering", "obsidian", "ai-agents", "personal-infrastructure", "claude"]
draft: false
---

> Photo by [Unsplash](https://unsplash.com/s/photos/digital-brain) — "A computer generated image of a brain surrounded by wires."

Here is the uncomfortable truth about your AI tools: they don't know you.

They know language. They know your codebase if you paste it in. They know the last thing you said in this session. But they don't know what you're working on this quarter, what failed last week, what your kid is named, or why you stopped using that framework. They are brilliant strangers — and every conversation starts from scratch.

That gap is where most of the productivity loss in AI-assisted work hides. And it's also where the next layer of personal infrastructure gets built.

I call that layer a **Personal Context Management System** — a PCMS. This post is about what it is, why you want one, and how the real leverage in an AI-first world isn't prompt engineering. It's context engineering.

## The world context problem

LLMs are pre-trained on the internet. That's enormous. But it's also generic. When you ask Claude "what should I do next?", it has no idea what "next" means for you. It has no idea what's on your plate, who you owe a reply to, which of your projects is stalled, or what your strengths and blind spots actually are.

So it does the only honest thing it can do: it gives you a generic answer. Reasonable, well-structured, and almost never the answer you actually needed.

This is the **world context problem**. The model has world knowledge but zero personal context. And the gap between "smart-sounding generic advice" and "the right move for me, today" is the difference between an AI being a toy and an AI being infrastructure.

You can close that gap in two ways:

1. **Re-explain yourself every session.** Paste in your context. Repeat your goals. Restate the project. Re-link the doc. This is what most people do, and it scales like garbage.
2. **Give the model durable access to your context.** Build a system. Let the AI read your notes the way a teammate would skim a doc before a meeting.

Option two is a PCMS.

## What a PCMS actually is

A PCMS isn't a product. It's a discipline plus a structure. The shortest definition I can give you:

> A PCMS is your notes, daily logs, goals, projects, and decisions — organized so that an AI agent can read them, reason over them, and act on them on your behalf.

In practice, mine looks like this:

- **An Obsidian vault** as the substrate. Markdown files. Folders for `Projects/`, `Resources/`, `Agents/`, `Planning/`, plus daily notes under `Resources/Agenda/Daily/`.
- **Daily notes** that capture what I did, what I'm thinking about, what's blocking me. Not a journal. A logbook.
- **A `Mission Control` page** that aggregates the state of active projects, pending decisions, and the next move on each.
- **Agent memory** — a unified memory file (`Resources/System/memory/MEMORY.md`) plus per-runtime memory indices that capture things agents learn about me across sessions.
- **An embeddings layer** (pgvector in Postgres, in my case) so semantic queries like "what were our concerns about the auth refactor?" actually return the right notes instead of keyword garbage.
- **Conventions and a glossary** — a `GLOSSARY.md` that defines my lingo (MCO, MHM, OV, CF) so an agent reading my notes doesn't have to guess.

That's it. No magic. The magic is that the structure is **machine-legible**. An agent can grep it, embed it, query it, and bring the right slice into context at the right time.

## The shift: from prompt engineering to context engineering

Prompt engineering was the right obsession in 2023. We were figuring out how to talk to a new kind of system. People wrote books about token tricks, role priming, chain-of-thought scaffolding. Some of it still matters.

But here in 2026, the bottleneck has moved.

> The model is no longer the limit. The context you give it is.

Frontier models are absurdly capable. Claude Opus, GPT-5, Gemini 3 — they're all roughly indistinguishable on most real-world tasks at the prompt level. The differentiator is no longer "how clever was your prompt?" It's "what did you put in the window?"

This is **context engineering**. The discipline of curating, structuring, and feeding the right information to a model at the right time. It includes:

- Deciding what to put in the system prompt vs. what to retrieve on demand
- Designing memory layers (ephemeral, working, persistent, semantic)
- Choosing what to embed and what to keep as flat markdown
- Knowing when to compress, when to summarize, and when to leave raw
- Writing notes in a way that future-you and future-agents can both parse

The work shifts from "how do I phrase the question" to "what does the model need to know before I even ask." That second question is a systems question. And the system that answers it is your PCMS.

## Wrapping Claude around your notes

The phrase I keep coming back to is "wrapping Claude around your notes."

The default usage of an AI assistant is the inverse: you bring the AI into a blank conversation, and you spoon-feed it everything it needs. That's wrapping yourself around the AI.

A PCMS flips it. The AI lives inside your context. It boots up already knowing:

- What projects you have open and their current state
- What you said in your last daily note
- What decisions you've made, and which ones you regretted
- What conventions you use (your glossary, your file naming, your routing rules)
- Who matters in your world — clients, teammates, people you owe a reply

The technical mechanics aren't exotic. You point the AI at your vault. You give it tools to read files, search, and write. You define a few conventions — where things live, what gets logged where, how agents should hand off. That's the bulk of it.

For me, that looks like:

- Claude Code with read/write access to my vault
- An `AGENTS.md` at the vault root that tells any agent the routing rules
- A `CLAUDE.md` per project that says "load these files before doing anything"
- A `memory-search` skill that any agent can call to query my unified memory across runtimes
- Daily notes that agents both *read* (to know what I'm doing) and *write* (to log what they did)

The first time you experience an agent that already knows the answer to "what was I working on yesterday?" without you reminding it, the prompt-engineering era starts to feel quaint.

## A PCMS is personal infrastructure

I want to be careful here, because there's a hype version of this idea that I'm not selling. I'm not telling you to "build your second brain" and journal for an hour every morning. I'm telling you that **the substrate for AI-assisted work is your own context**, and if you don't own that substrate, you'll spend the next ten years renting it from whichever vendor is cheapest this quarter.

Think of it the way you think about a dotfiles repo, or a home lab, or your shell config. Personal infrastructure. It compounds.

Here is how that compounding actually looks:

- **Week 1:** You start daily notes. You add a glossary. The AI starts giving slightly less generic answers.
- **Month 1:** You have a few hundred notes. You add an embeddings layer. Semantic search starts surfacing notes you forgot you wrote.
- **Month 3:** You add a morning report agent that compiles "what's on your plate today" from active projects, calendar, and yesterday's notes. You stop opening five tabs to figure out what to work on.
- **Month 6:** You add a wind-down agent that triages the day, files things into the vault, and writes tomorrow's agenda. The system is now spending energy *for* you instead of *on* you.
- **Year 1:** You can ask an agent a question like "what did I learn the last time I tried to refactor the auth flow?" and get a real answer with citations to your own decisions.

That last one is the moment a PCMS earns its keep. You stop being amnesiac at the system level. Your AI becomes a colleague with institutional memory — your institution.

## What this looks like in practice

A few concrete patterns from my own setup, so this doesn't stay abstract.

**Morning report.** A scheduled job at 6:30am MDT runs a "kimi" skill against my vault. It pulls the last 24 hours of activity, my active projects, calendar, and any open decisions. It produces a short briefing — three paragraphs, five bullets — and drops it into a shareable view. I read it with coffee instead of opening Slack.

**Wind-down triage.** At 9pm MDT, a different job sweeps the day. It looks at what agents did, what I committed, what's still open. It writes tomorrow's `today.md` with three things ranked by priority. If something failed, it logs why and what to try next. Future-me thanks past-me.

**Cross-session continuity.** When I open a new Claude Code session, the first thing it loads is `AGENTS.md`, then the project's `CLAUDE.md`, then a memory index. By the time I type my first message, the agent already knows the project, the conventions, the recent activity, and my open questions. I never have to explain "what we're doing" again.

**Active project routing.** I have a "router" agent (Izzy) whose only job is to figure out which agent should handle a request. She knows that "red team this site" goes to Cerberus, "ship the blog post" goes to Scribble, "what's the status of the integration" goes to a project-specific researcher. She knows because the vault tells her — she's reading the same `AGENTS.md` I'd read if I were onboarding a teammate.

None of these are clever prompts. They are conventions plus structure plus a model that can read.

## Where to start

If you've made it this far and you're nodding along, the practical advice is shorter than the pitch:

1. **Pick a vault.** Obsidian, a folder of markdown, whatever. Local-first. Plain text. Greppable.
2. **Start a daily note.** One file a day. Log what you did, what's blocking you, what's next. Even a few lines is enough.
3. **Write a glossary.** Five terms you use that an outsider wouldn't know. Add to it as you go.
4. **Add a `Projects/` folder.** One folder per active thing. Each has a `README.md` with current state and next move.
5. **Point an AI at it.** Claude Code, Cursor, whatever — give it read access. Ask it questions about your own notes. Watch what breaks.
6. **Fix the breaks with structure, not prompts.** When the AI gets confused, the answer is almost never "phrase the prompt better." It's "make the structure clearer."

That's the loop. Capture, structure, expose, iterate. Do it for ninety days and you will be operating in a different category from everyone still pasting context into a chat box.

## The closing argument

The next decade of knowledge work is going to be defined by how well people own their own context. The tools will keep getting better, faster, cheaper. The models will become commodities. The differentiator — the thing that determines whether AI is a toy or a force multiplier for you specifically — is the substrate underneath.

A PCMS is that substrate. It's the difference between an AI that gives you "best practices" and an AI that gives you *your* next move. It's the difference between renting intelligence and compounding it.

Stop trying to phrase the perfect prompt. Start building the context layer the prompt sits on top of.

Your AI doesn't know you yet. Fix that.

---

*If you want to see how this is wired up in practice — the actual vault structure, the agent definitions, the memory protocol — most of it is open and documented at [github.com/peb7268](https://github.com/peb7268). The blog you're reading now is itself part of the system: written in Obsidian, published by an agent named Scribble, syndicated by another one named Socialite. The PCMS writes about itself.*

Sources:
- [Unsplash — Digital Brain](https://unsplash.com/s/photos/digital-brain)
- [Unsplash — Knowledge](https://unsplash.com/s/photos/knowledge)
- [The Second Brain methodology overview](https://medium.com/@kulwantsaluja/the-second-brain-a-deep-dive-into-the-digital-productivity-revolution-921cf8acd48d)
