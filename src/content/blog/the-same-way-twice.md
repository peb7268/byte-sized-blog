---
title: 'The Same Way Twice'
description: "An agent that does the same task two different ways hasn't given you leverage — it's given you a thing you now have to re-review every run. Spec-driven development is how you get determinism, and determinism is the floor that runtime governance is built on."
pubDate: 'Jun 28 2026'
heroImage: 'https://images.unsplash.com/photo-1465847899084-d164df4dedc6'
draft: true
series: 'Agentic Governance'
seriesOrder: 2
tags: ['agentic-ai', 'spec-driven-development', 'runtime-governance']
---

In the [last piece](/blog/the-review-is-the-work-now/) I ended on a metaphor and then walked away from it before earning it. I said the job had moved from soloist to conductor, and that our work as leaders is to "build tools that make the score worth reading." A conductor's score, readable at a glance.

I want to come back and pull on that thread, because the metaphor is load-bearing in a way I didn't say out loud: a score's entire reason for existing is that the orchestra can play the same piece *the same way twice*. Different hall, different night, different second violin — same symphony. The notation is what makes a performance reproducible instead of a one-off improvisation that happened to sound good once.

That is exactly the thing most agentic setups are missing. And it's the quietest, most expensive failure mode in the whole space.

## The two-runs test

Here's a test I've started running on any agentic workflow before I'll trust it with anything that matters. Give the agent the same task twice, in two fresh sessions. Then diff the two results.

The first time I did this seriously, the output wasn't *wrong* either time. Both runs shipped something that worked. But they worked *differently* — different file layout, different names, a helper extracted in one and inlined in the other, a slightly different interpretation of an ambiguous requirement. Two competent strangers, handed the same ticket, producing two competent-but-divergent solutions.

For a human pair that's fine; you talk it out. For an agent you're trying to *scale*, it's a problem dressed up as a feature. Because if the agent does the task a different way every time, you haven't bought leverage. You've bought a thing you have to fully re-review on every single run, forever, because you can never carry forward a mental model of "how it does this" — there is no *how*. There's just this run's how.

That's the tell. The same word from last time — *organically* — was the developer fear of losing the model in his own head. This is the structural version of the same loss: **there's no stable model of the system's behavior to hold, because the behavior isn't stable.**

## Reproducibility is the actual deliverable

We talk about agents in terms of capability — can it do the task. That's the wrong axis once you're past the demo. Past the demo, the axis is: *can it do the task the same way twice.*

Capability without reproducibility is a magic trick. It's great in a keynote and a liability in a system, because everything you'd want to build *on top* of the agent — tests, monitoring, trust, the ability to hand a teammate "here's how our agents do migrations" — assumes the behavior has a shape you can point at. A non-deterministic agent has no shape. It has a distribution.

And LLMs are stochastic by construction. Temperature, sampling, context order, the exact phrasing of the prompt, the order tools happen to return — all of it nudges the output. Left alone, an agent's behavior is a cloud, not a point. The interesting engineering question is not "how do I make the cloud bigger and more capable." It's **"how do I collapse the cloud to a point I chose."**

## The spec is how you collapse the cloud

This is where spec-driven development stops being a documentation chore and starts being the actual control surface.

A spec — a real one, the kind that names the inputs, the outputs, the invariants, the acceptance criteria, the explicit *non*-goals — does one thing above all: it removes the ambiguity the model would otherwise resolve differently each run. Every place your spec is silent is a place the agent will improvise, and improvisation is exactly where the two runs diverged. The spec is the score. It's the difference between "play something triumphant here" and the actual notes.

Tighten the spec and the distribution narrows. Tighten it enough — inputs, outputs, the shape of the solution, the things it must *not* do — and two runs converge. Not because the model got more deterministic under the hood, but because you removed the degrees of freedom it was using to wander. You collapsed the cloud to the point you specified.

That reframes "the spec docs are too technical and take too long to read" — the complaint I flagged last time — into something sharper. The fix isn't fewer specs. It's *legible* specs that are nonetheless *complete enough to pin behavior.* Legibility and precision aren't in tension here; vagueness is the enemy of both. A vague spec is both hard to review and useless at collapsing the cloud. The bar is the conductor's score again: precise enough that the orchestra converges, readable enough that you can follow it at a glance.

## Why this is a governance pillar, not a productivity tip

It would be easy to file all of this under "ways to make agents more useful." It belongs somewhere more serious. In the governance frame, this is **Runtime Governance and Behavioral Drift** — the discipline of detecting when an agent's behavior starts shifting away from its original intent.

Sit with that definition for a second, because it contains a quiet prerequisite almost nobody states: **you cannot detect drift from a baseline you never established.** Drift is deviation from intent. If "intent" was never written down — if it lived only in the vibe of whoever prompted the agent that afternoon — then there is nothing for the behavior to drift *from*, and nothing to measure against. You can't govern a cloud.

So spec-driven development is the design-time half of this pillar, and it's the half that has to come first. The spec is intent, made explicit and machine-checkable. It's the fixed point. Once you have it, the monitoring half becomes possible: you can diff a live run against the spec, flag the runs that wandered, and catch drift as a *measured deviation* instead of a *gut feeling that something's off lately.* Determinism isn't the opposite of governance overhead. Determinism is the thing that makes governance cheap — it turns "is the agent still doing the right thing?" from an act of faith into a diff.

Skip it, and you get the failure mode I keep watching teams back into: agents that are individually impressive and collectively ungovernable, where every run is a fresh negotiation with chaos, where "it's behaving weirdly today" can't be confirmed or denied because there was never a defined *normal*. That's not an AI problem. It's a missing-score problem.

## What this looks like in practice

Concretely, for anyone building this out:

- **Run the two-runs test on anything you're about to trust.** Same task, two fresh sessions, diff the results. The size of the diff is your reproducibility score. If it's large, you don't have a workflow yet — you have a slot machine that pays out in working code.
- **Treat every divergence as a hole in the spec, not a quirk of the model.** Where the two runs disagreed is precisely where your spec was silent. Close that gap and re-run. The spec gets tighter exactly where it needs to.
- **Pin the obvious sources of nondeterminism.** Temperature, model version, tool order, the contents of the context window. You won't get to bit-for-bit identical, and you don't need to — you need *behaviorally* the same: same structure, same decisions, same invariants honored.
- **Make the spec the artifact you version and review** — not the output. The output is downstream and disposable; the spec is the source of truth. If you're reviewing generated code instead of the spec that generated it, you're proofreading the performance instead of correcting the score.

## The honest version

Capability is the part that demos well, so it's the part we talk about. But the teams that will actually compound with agents aren't the ones whose agents can do the most impressive single thing. They're the ones whose agents do the *same* thing, the same way, every time — because that's the only kind of behavior you can build trust, tests, and oversight on top of.

The conductor's job was never to be the most virtuosic player in the room. It was to make sure that what's in everyone's heads collapses, every night, onto the same score. Spec-driven development is how we write that score for agents. And reproducibility — boring, unglamorous, doing-it-the-same-way-twice reproducibility — turns out to be the floor the whole governance project stands on. You can't watch for drift until you've decided, in writing, what "not drifting" means.

How are you handling this on your own agentic workflows — are you specifying behavior tightly enough that two runs converge, or are you still re-reviewing every run from scratch? I'd like to compare notes, especially with anyone who's found the right altitude for a spec: tight enough to pin behavior, light enough to actually read.
