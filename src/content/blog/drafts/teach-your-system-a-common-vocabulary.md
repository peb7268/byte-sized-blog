---
title: 'Teach Your System a Common Vocabulary'
description: "Your agent doesn't know that 'the OV' means your Obsidian vault, or that 'Tower' is your NAS. You've spent years building a private shorthand — teach it to your system once, load it every session, and your terse instructions suddenly land."
pubDate: 'Jul 21 2026'
draft: true
series: 'Agentic Foundations'
seriesOrder: 4
tags: ['agentic-ai', 'context-engineering', 'fundamentals']
hashtags: ['agenticdevelopment', 'contextengineering', 'aiengineering']
---

Watch what happens the first time you talk to a fresh agent the way you talk to yourself.

*"Drop it in the OV under today's DN, then deploy the change to Tower."*

To you, that sentence is unambiguous. To a brand-new agent it's four guesses stacked on top of each other: OV? DN? Tower? *deploy how, to where?* It will either stop and ask, or — worse — confidently invent an answer and act on it. You didn't give it a bad instruction. You gave it a **private language it was never taught.**

This is one of the cheapest, highest-leverage things you can do for an agentic setup, and almost nobody does it deliberately: **teach your system the vocabulary you already think in.**

## You have a private language. You just never wrote it down.

Every person who works in software accretes a personal shorthand over years — the names of your machines, your folders, your projects, the two-letter abbreviations you'd never spell out. It lives in your head and leaks into everything you say. When you worked alone, or with people who'd absorbed it by osmosis, that was fine. Now you're handing tasks to an agent that has *zero* osmosis. It knows the entire public internet and nothing about your world.

So the fix is boring and powerful: write the private language down, in one place, and make your system read it before every session. It's [context engineering](/blog/context-is-king/) at the vocabulary layer — the smallest, densest, most reusable context you can supply.

There are two halves to it.

## Half one: name your artifacts

These are the *things* in your world — the machines, servers, and named systems you point at constantly. Give each one a name and a one-line definition, and suddenly "deploy to Tower" is an address, not a riddle.

Mine, for example:

- **Tower** — my NAS (an Unraid box). It runs the containers: the databases, the sales system, the tunnels. "Ship it to Tower" means something exact.
- **MBP** — my MacBook Pro. The primary machine where the local harness runs.
- **UDM** — the Ubiquiti Dream Machine, the router/gateway. When I say "open a port on the UDM," there's no ambiguity about which device.
- **Optimus** — my personal context engine (the dashboard the whole vault feeds into).
- **Pipe** — the sales/calling system. Not a Unix pipe. *My* Pipe.

Without the glossary, "Pipe" is a coin flip between a shell primitive and my product. With it, the agent never wastes a turn guessing — and never confidently ships to the wrong place.

## Half two: teach your abbreviations

These are the two- and three-letter shortcuts you use so often you've forgotten they're jargon. This is where new agents fall down hardest, because the abbreviations *look* like they could mean anything.

A slice of mine:

- **OV** — Obsidian Vault. The whole knowledge base.
- **DN** — Daily Note. **WN** — Weekly Note. **MN** — Monthly Note.
- **ZK** — Zettelkasten (the atomic-notes folder).
- **MC** — Mission Control, my main dashboard.
- **PCMS** — Personal Context Management System — the whole philosophy the vault runs on.
- **MHM** — Mile High Marketing, one of my businesses. **TT** — the Trigger Table that tells an agent what context to load when.

"Add it to the DN" is a shrug to a stranger and a precise instruction to a system that's been taught. The abbreviation didn't get *shorter* to write — it got **safe** to write.

## Why this pays for itself immediately

Three things happen the moment your system speaks your language:

1. **Your terseness becomes precision, not ambiguity.** The whole appeal of shorthand is that it's fast. Normally, speed and clarity trade off — the terser you get, the more the reader has to guess. A shared glossary breaks that trade-off: you get to be terse *and* exact, because the density is backed by a definition the agent actually holds.
2. **It stops the confident wrong answer.** An untaught agent rarely says "I don't know what OV is." It fills the gap with a plausible guess and moves on — and a plausible guess acting on your files is exactly the [failure mode you don't want](/blog/garbage-in-gospel-out/). A glossary replaces the guess with a fact.
3. **You stop re-explaining yourself.** Without it, every session starts with you spelling out the same context. With it, you say the two letters and get on with the work. The explaining moved from "every prompt" to "once, in a file."

## How to actually do it

The mechanism is almost embarrassingly simple:

- **Keep one authoritative glossary file.** One place, not scattered notes. Mine is a single `GLOSSARY.md`.
- **Load it every session.** This is the part people skip. A glossary the agent doesn't read is a diary. Wire it into your harness so it's pulled into context automatically at the start of every run — for me, the vault's top-level rules file *imports* the glossary, so no session starts without it.
- **Keep it authoritative and current.** When you name a new machine or coin a new abbreviation, it goes in the glossary the same day. The glossary is the source of truth; if it and your memory disagree, the glossary wins (that's the whole point — so the agent and you never drift).
- **Start with what you actually say.** Don't try to be exhaustive on day one. Skim a few of your own recent messages, pull out every name and abbreviation you used without defining, and write those down first. That list *is* your working vocabulary.

## The tell

Here's how you know it's working: your instructions to the agent start to read exactly like the notes you write to yourself. Same names, same abbreviations, same brevity — and the agent keeps up. That's the goal. You're not dumbing down your language to be understood. You taught the system to speak it.

Context is the work. Vocabulary is the first, cheapest layer of it — and it's the one that makes every layer above it terser and truer at the same time.
