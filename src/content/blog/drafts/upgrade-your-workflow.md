---
title: 'Upgrade Your Workflow'
description: "Working with agents isn't a faster version of the old job — it's a different operating system. Here are the six meta-skills that run on it, and the series that unpacks each one."
pubDate: 'Jun 29 2026'
draft: true
series: 'The New Ways of Working'
seriesOrder: 1
tags: ['agentic-workflow', 'meta-skills', 'developer-productivity']
hashtags: ['agenticdevelopment', 'aiengineering', 'newwaysofworking']
---

Most people trying to "use AI more" are running new hardware on an old operating system. They bolt an agent onto the exact workflow they had in 2023 — same single screen, same one task at a time, same habit of doing the thing themselves and reaching for the model only when stuck — and then wonder why the productivity miracle never shows up. The tool is new. The way of working is not. And the way of working is the whole game.

I want to name the thing directly: working with agents is a different **operating system**, not a faster app. It has its own primitives, its own skills, its own failure modes. You don't get the gains by typing prompts into the margins of your old process. You get them by replacing the process. This post is the map of that replacement — six meta-skills that, together, make up the new OS. Each one gets its own post in this series. Consider this the index.

I've argued in other pieces that [the review is the work now](/blog/the-review-is-the-work-now/) and that [intelligence moves up the stack](/blog/intelligence-moves-up-the-stack/) toward judgment and intent. Those are *consequences*. This is the layer underneath them — the actual habits you rewire to live in that world.

## 1. Maintain a PCMS — your durable context

Start here, because everything else leans on it.

A **PCMS** is a *personal context management system*: the durable, structured record of what you know, what you've decided, and how your work is supposed to be done — kept in a form an agent can actually consume. Not in your head. Not scattered across forty Slack threads and a notebook. Written down, organized, and reusable.

Here's why it's foundational. An agent has no memory of you between sessions. Every run starts from amnesia, and whatever context you fail to supply, it invents or ignores. If you re-explain your project, your conventions, and your preferences from scratch every single time, you are paying full price for context on every task forever. The PCMS is how you stop doing that — you write the context *once*, well, and pipe it in.

This is the single highest-leverage habit in the entire OS, which is why it gets its own deep treatment in the [PCMS manifesto](/blog/pcms-manifesto/). The short version: the people who get structured, reliable output from agents are not the ones with the cleverest prompts. They're the ones with the best-maintained context. Your PCMS *is* your edge.

## 2. Delegate the mundane

Once you have durable context, you can hand work off — and the first thing to hand off is everything that doesn't require you.

The instinct most engineers fight is the feeling that delegating is somehow cheating, or that explaining the task takes longer than just doing it. Sometimes, for a one-off, that's even true. But the mundane work — the boilerplate, the rename-across-forty-files, the test scaffold, the changelog entry, the "go read these six files and summarize what they do" — is exactly the work that drains your day while contributing nothing to your judgment. It's the work you'll never get better at by doing more of.

**Delegate it.** Not because the agent is brilliant at it, but because *it doesn't need you to be brilliant.* The skill here is recognizing, in the moment, "this does not require my brain" and routing it away before you sink twenty minutes into it on autopilot. Every mundane task you reflexively do yourself is a tax on the thinking you're actually paid for.

The catch — and it's a real one — is that delegation is only safe if you can review the result, which is why this skill and the PCMS arrive before all the others. Garbage context produces garbage you have to redo. Good context produces output you can wave through.

## 3. Build systems to multi-thread yourself

This is the one that changes the felt experience of the job the most, so sit with it.

You are single-threaded. You can hold one hard problem in your head at a time. Agents are not single-threaded — you can have three of them working at once. The meta-skill is building your workflow so that **while the agents work, you don't wait.** You think about the next problem. You explore the part of the codebase you've never understood. You review what the last agent produced. You write the spec for the thing after this one.

The old loop was: do work, wait for build/test/feedback, do more work. The wait was dead time. In the new OS, the agent's run *is* your wait — and you fill it with parallel cognition instead of staring at a progress bar. Done right, your own attention becomes the scarce resource you're scheduling across multiple streams, the way a CPU schedules threads.

This is what [orchestration](/blog/orchestration/) really means in practice, and it's the difference between people who feel *busier* with agents and people who feel *bigger*. The former kicked off a task and watched it. The latter kicked off three and used the gap to out-think all three. Multi-threading yourself is a discipline you have to build deliberately — it does not happen by accident, because every instinct you have says "watch the thing you started."

## 4. Treat each run as an empirical signal

Here's the mindset shift that compounds the hardest over time.

Every agent run is an experiment. It either went well or it didn't, and *both outcomes are data.* The amateur move is to treat a bad run as bad luck — re-roll, try again, shrug. The professional move is to ask: **why did this go wrong, and what do I change so it can't go wrong the same way again?**

The answer is almost always one of a few levers. Strengthen the context — the agent didn't have what it needed, so the PCMS gets better. Add a rule — it did something you don't want, so you write the constraint down once and it holds forever. Add or replace an agent — the task needed a specialist you didn't have, or the one you had was wrong for it. The point is that the system is *tunable*, and each run tells you exactly which knob to turn.

This is how a workflow that's mediocre in month one becomes formidable by month three. Not because the models got better (though they will). Because *you* ran a hundred experiments and folded every lesson back into the system. The run is not just output. It's a measurement of your setup — and your setup is the thing you're really building.

## 5. Open more lines of communication

Now widen the surface.

Most people talk to their models through exactly one channel: a chat box on a laptop. That's like owning a phone and only ever using it at your desk. The meta-skill is asking, deliberately, **how many modalities and channels can I reach my models through?** Terminal. Editor. A chat app on your phone. Voice. A message bus where agents hand work to each other. A scheduled job that runs while you sleep.

Every channel you open is a new moment where work can happen — a thought you can dispatch from a walk, a review you can approve from the couch, a pipeline that fires at 3 a.m. without you. The constraint on your output stops being "am I at my desk" and starts being "did I have the idea." Widening the lines of communication is how you collect the dead moments of your day — the commute, the queue, the in-between — and turn them into dispatch points.

The narrower your interface to your models, the smaller your effective workforce, no matter how capable the underlying model is.

## 6. Untether

And the last one follows directly: stop being chained to one screen.

If your work only happens when you're sitting in front of a specific machine, in a specific session, you've recreated the exact constraint the whole OS is supposed to remove. The agents don't need you in the chair. They need you to *decide, dispatch, and review* — and none of those require a desk. **Untethering** is the deliberate practice of designing your workflow so it survives you walking away from it.

This is partly technical — the channels from skill five, the durable context from skill one, the systems from skill three — and partly psychological. You have to let go of the belief that work isn't real unless you're watching it happen. The conductor doesn't play every note. Increasingly, the conductor doesn't even have to stay in the hall.

## The OS, assembled

Look at how they stack, because the order is not arbitrary:

- **PCMS** gives you durable context.
- **Delegation** spends that context to offload the mundane.
- **Multi-threading** fills the time delegation frees up.
- **Empirical tuning** makes every run improve the system.
- **More channels** widen where work can happen.
- **Untethering** frees you from the chair entirely.

Each one builds on the last. Skip the PCMS and delegation is unsafe. Skip multi-threading and you're just a slower bottleneck with fancier tools. Skip the empirical loop and your setup never improves. They're not a menu — they're a stack.

None of this is about typing prompts faster. It's about running a fundamentally different operating system for how work gets done — one where your judgment is the scarce resource and everything around it is built to spend that resource as well as possible. The rest of this series takes each meta-skill apart and shows you how to build it.

Upgrade the workflow, not just the tools. That's the whole move.
