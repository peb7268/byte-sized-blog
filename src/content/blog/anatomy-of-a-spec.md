---
title: 'Anatomy of a Spec'
description: "The series kept insisting you need a spec. None of it told you how to write one. Here's the anatomy — the parts most specs are missing, the altitude problem that's the actual craft, and the test that tells you it's done."
pubDate: 'Jun 28 2026'
heroImage: 'https://images.unsplash.com/photo-1503387762-592deb58ef4e'
draft: false
hashtags: ['agenticdevelopment', 'contextengineering', 'softwareengineering']
socialQuote: "A vague spec is a wish. A precise spec is a program you didn't have to type."
series: 'Agentic Engineering'
seriesOrder: 5
---

This series has been one long argument that structured intent beats raw capability. [The review is the work now](/blog/the-review-is-the-work-now/) because your judgment is the scarce input. [Reproducibility comes from a spec](/blog/the-same-way-twice/), not a vibe. [GIGO never died](/blog/easy-bake-oven-developers/) — random context in, mush out. And [the leverage moved up the stack to intent](/blog/intelligence-moves-up-the-stack/).

Four posts insisting you need a spec. Not one of them told you how to write one. That's the gap I want to close, because "write a spec" is the kind of advice that *sounds* actionable and isn't — right up until someone shows you the parts.

## A spec is not documentation

First, kill the wrong mental model. A spec is not a writeup. Documentation describes something that already exists; a spec describes something that *doesn't exist yet*, precisely enough that a machine can bring it into being the same way twice. Documentation is past tense. A spec is imperative.

It's also not a chore you do around the work. It **is** the work now — the control surface you steer with, since you're no longer typing the implementation. Treat it as an afterthought and you've handed the most important artifact in the loop to whoever wrote the vaguest sentence.

There's a binder analogy I keep coming back to. Drop a junior developer into your codebase with no context and you get generic, surface-level work. Drop a senior — better instincts, still lost without the domain. Drop a genuine world-class expert and they *still* need your conventions, your history, your constraints before they're any use. Expertise without context is potential energy. The model is the expert. **The spec is the binder you hand it** — the thing that turns potential into output that actually fits your system.

## The anatomy

A real spec has parts, like a real organism. Most "specs" are missing organs, and you can predict exactly how the result will fail by which organ is absent.

- **Intent — the why.** What should be true when this is done, and *why it matters*. Not the steps — the outcome and the reason. The reason is load-bearing: it's what lets the agent make the thousand tiny decisions you never spelled out, in the direction you'd have chosen.
- **Inputs.** What it gets. Concrete — shapes, sources, a real example. "The data" is not an input. `a JSON array of orders shaped like {…}` is.
- **Outputs.** What it produces. The contract the rest of the system depends on.
- **Invariants.** What must stay true the whole way through. The rules that don't bend no matter what.
- **Non-goals.** What it must explicitly *not* do. This is the most-skipped, highest-value organ in the whole body. Every non-goal you write closes a door the agent would otherwise happily wander through. "Don't touch the auth flow. Don't add a dependency. Don't change the public API." Three sentences, a dozen disasters prevented.
- **Acceptance criteria.** How you — or a test, or another agent — will *know* it's done. Falsifiable, not vibes. This is the seam to verification, which is its own post.
- **Examples.** One good example is worth a paragraph of prose. Show the shape of a correct result; the model pattern-matches to it harder than to any adjective.
- **Constraints.** The boundaries — performance, security, style, "use the existing utility, don't invent a new one."

Here's the tell that you have a spec and not a wish: **every place it's silent is a place the agent will improvise** — and improvisation is exactly where the two runs diverged last time. The spec is the score. Silence is where the orchestra starts soloing.

## The altitude problem

The parts are the easy half. The hard half — the actual craft — is **altitude**.

Fly too high and you've written "make it better": the slot machine, a different plausible result every pull. Fly too low and you've specified every line: congratulations, you wrote the code in English, slower than you'd have written it in code. Neither is a spec. One is a wish; the other is a transcription.

The skill is finding the altitude where the spec pins the **outcome and the invariants** without dictating the **implementation** — high enough to leave the *how* to the machine, low enough that two runs converge on the same shape. That altitude is the whole game of operating at the [intent layer](/blog/intelligence-moves-up-the-stack/). It's not natural, and it's not free; it's a skill you build by writing specs, running them, and watching where they leak.

## Standing specs vs. task specs

There are two kinds, and conflating them is how context systems rot.

The **task spec** is what you write per job — this PR, this bug, this feature. The **standing spec** is the context that's always loaded: your `CLAUDE.md` (the project's constitution), your agents (on-demand expertise), your skills (invokable workflows). The standing spec is the part of the binder you don't re-hand every time — the hard rules, the conventions, the "where things live."

Layer them deliberately. Hard rules and conventions belong in the always-on layer. Task-specific intent belongs in the task spec. Put reference docs in your constitution, or bury a hard rule in a one-off prompt, and the whole thing decays — the standing context goes stale and the task context goes vague. A 10K-token always-on file that loads every session had better earn its keep every session.

## You already know when it's done

The test is the same [two-runs test](/blog/the-same-way-twice/). Write the spec, hand it to two fresh sessions, diff the results. Wherever they diverge is precisely where your spec was silent. Close that gap and re-run. The size of the diff is your spec's coverage score.

A spec isn't finished when it *reads* well. It's finished when two competent strangers — or two agent runs — produce the same shape from it. Readability is necessary; convergence is the bar.

## The honest version

We spent decades getting good at writing code. The new literacy is writing the thing that writes the code, and it's genuinely a *different* skill — closer to legislation than to programming. You're declaring what must be true and what must never happen, and delegating the how to something that can execute it a thousand times without getting bored.

A vague spec is a wish. A precise spec is a program you didn't have to type. The engineers who feel the floor rising under them aren't the ones with the best prompts — they're the ones who learned to write at the right altitude.

So: pull up your last "the AI did it wrong" moment and read it as a spec review. Which organ was missing — the non-goals, the acceptance criteria, the example? I'd bet it wasn't the model that failed. And I'd like to hear which organ people find hardest to remember to write — mine's the non-goals, every time.
