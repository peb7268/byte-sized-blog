---
title: 'Context Is King'
description: "Every post in this series leans on one word and never defines it: context. It's not the setting for the work — it's the medium. Here's what a context window actually is, and the four moves that separate engineers who get structured output from ones who get slop."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1507842217343-583bb7270b66'
draft: true
series: 'Agentic Foundations'
seriesOrder: 3
tags: ['agentic-ai', 'context-engineering', 'fundamentals']
hashtags: ['agenticdevelopment', 'aiengineering', 'contextengineering']
---

I've written a lot of words in this series about what changes when agents take over execution — that your value moves up to judgment, that intent is the new artifact, that the review *is* the work. And every one of those posts quietly leaned on a single word without ever stopping to define it.

**Context.**

"Supply the right context." "The agent lost the thread of the context." "Context poisoning." I kept using it like it was self-evident. It isn't. So let me back all the way up and say the thing the rest of the series assumes:

> Context is not the *setting* for agentic work. It **is** the work. It's the medium you operate in, the way a painter operates in paint. Get good at the medium and everything downstream gets easier. Stay sloppy with it and no amount of clever prompting saves you.

This is the missing foundation. Let's lay it.

## What a context window actually is

Strip away the mystique. A large language model has no memory of you, your codebase, your last conversation, or what it did thirty seconds ago. It has exactly one input: **the block of text you hand it on this turn.** That block — everything the model can "see" at once — is the **context window**.

Think of it less like a brain and more like a brilliant contractor with total amnesia who is handed a single manila folder before each task. Whatever's in the folder, they use. Whatever's missing, they invent or ignore. They don't remember yesterday's folder. They can't ask you a clarifying question and hold the answer for later. The folder is the entire world.

The context window has a finite size, measured in **tokens** (roughly ¾ of a word each). Everything competes for that space: your instructions, the relevant files, the conversation so far, tool outputs, the rules you've set. When people say a model "got dumber" mid-session, what usually happened is the folder got stuffed with noise and the signal got buried — or it overflowed and the earliest, most important pages fell out the back.

So the entire game is: **what goes in the folder, and in what shape?** That's context engineering. And it has exactly four moves.

## Move 1 — Load: get the right material in

The first failure mode isn't too little context. It's the *wrong* context, loaded indiscriminately.

I wrote a whole post ([Easy Bake Oven Developers](/blog/easy-bake-oven-developers/)) about engineers who dump a random pile of files into the window, expect structured output, and blame the model when they get slop. Garbage in, gospel out. Loading is where that's won or lost.

Good loading is *selective*. The skill is knowing what this specific task needs — the two files that matter, the interface contract, the one example of the pattern you want followed — and leaving out the forty that don't. More is not better. **Relevant is better.** A tight folder beats a fat one every time, because every irrelevant page you add is a page the model has to wade through to find the signal.

## Move 2 — Curate: shape it so the signal survives

Loading gets the material in. Curation makes it *usable*.

The same facts, structured well versus dumped raw, produce wildly different results — because the model spends its attention on whatever is loudest, not whatever is most important. Curation is editing the folder: putting the instructions up top, summarizing the long thing instead of pasting it whole, stating the invariants explicitly instead of hoping they're inferred, and cutting the stale page that now *contradicts* the current goal.

That last one matters more than people think. [Context poisoning](/blog/garbage-in-gospel-out/) — the agent confidently building on a wrong assumption that's sitting in the window — is a curation failure. The bad page never got removed, so it kept getting treated as gospel. Curation is the immune system.

## Move 3 — Pipeline: stop hand-feeding the folder

The first two moves are things you can do by hand, once. The leverage shows up when you stop doing them by hand.

A **context pipeline** is a system that assembles the right folder automatically, every time, for a given kind of task. Reviewing a PR? The pipeline pulls the diff, the relevant module docs, the team's review standards, and the linked ticket — and hands the agent a folder that's already curated. You're no longer copy-pasting; you're maintaining the *machine that builds the context.*

This is the same altitude shift the rest of the series keeps pointing at. In [Intelligence Moves Up the Stack](/blog/intelligence-moves-up-the-stack/) the move was from writing code to expressing intent. Here it's the same climb: from hand-loading context to **engineering the system that loads it**. The people who win at agentic development aren't the ones with the cleverest one-off prompts. They're the ones who built a pipeline so the hundredth task gets the same disciplined folder as the first.

## Move 4 — Cache: don't pay for the same context twice

The last move is the cheapest to ignore and the most expensive to skip at scale.

A lot of what goes in the folder is *stable* — your system instructions, the project's ground rules, the big reference doc that doesn't change between turns. Re-sending it every single turn means re-reading (and re-paying for) the same pages over and over. **Caching** is telling the system "this part of the folder didn't change — reuse it." Done right it cuts both latency and cost dramatically, because the model only processes the new pages, not the whole manila folder from scratch each time.

Most harnesses now do a version of this automatically when you keep the stable stuff in a consistent place. Which is itself a lesson: structure the folder so the unchanging parts are reusable, and the tooling rewards you for free.

## The job has a name now

Load. Curate. Pipeline. Cache. That's not a workflow tip — it's the core competency of working with agents at all.

Here's the reframe I want to leave you with. We used to think the scarce skill was *generating* the right output. With agents, generation is cheap and getting cheaper. The scarce skill is **assembling the conditions under which the right output is the likely one** — and those conditions live entirely in the context window.

The model is the engine. Context is the fuel, the road, and the map. Intent without context is a wish. Intent *with* well-engineered context is a program that runs.

Get good at the medium. Everything else in this series is downstream of it.
