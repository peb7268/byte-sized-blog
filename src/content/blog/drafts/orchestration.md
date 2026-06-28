---
title: 'Orchestration'
description: "A spec you write and walk away from is a New Year's resolution. The hard part isn't defining intent — it's keeping it in force: guardrails that hold the line, a workflow that drives the spec, a plan that outlives the session, and drift detection that catches the gap."
pubDate: 'Jun 28 2026'
heroImage: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64'
draft: true
hashtags: ['agenticdevelopment', 'aiengineering', 'softwareengineering']
socialQuote: "Conversations are RAM. Implementation plans are disk. Encode your intent in the durable substrate or watch it evaporate at the next /clear."
series: 'Agentic Engineering'
seriesOrder: 7
---

[Anatomy of a Spec](/blog/anatomy-of-a-spec/) was about writing intent down. [Trust but Verify](/blog/trust-but-verify/) was about confirming the output. But there's a long, messy stretch between those two — the part where the agent is actually *working* — and that's where things quietly fall apart.

Because a spec you write and then walk away from is a New Year's resolution. Beautifully phrased, full of intent, and completely defenseless against the next forty steps. The hard part of agentic engineering isn't *defining* intent. It's keeping intent **in force** — on track, alive across time, and honest about whether the thing you built is still the thing you specified.

That's orchestration. Four problems, four answers.

## Keeping agents on track: guardrails, not scripts

The instinct, when an agent drifts off the spec, is to script it harder — spell out every step so it can't deviate. That's a trap. If you're writing every step, you've gone back to coding, slowly, in English. The agentic move is the opposite: **delegate the decisions, and put guardrails around them.** You're not writing the steps; you're defining the walls the agent can't go through while it figures out the steps itself.

The cheapest, most durable guardrails aren't in your prompt — they're **hooks**. Pre-tool hooks block the things your spec said never to do: no `rm -rf`, no `git push --force`, no touching the auth flow. Your spec's *non-goals* stop being polite requests and become walls the agent physically can't walk through. Post-tool hooks log every action for audit. Pre-commit hooks gate the word "done" behind real checks — lint, types, tests — so the agent literally cannot claim success if the commit won't pass.

This is the difference between *hoping* the agent respects the spec and *engineering* a system where it can't violate it. And it's tunable: tighten the guardrails where the agent keeps stumbling, loosen them where it's earned trust. Guardrails aren't a cage — they're the banks of the river. The agent still does the flowing.

## Driving the spec: a durable workflow, not one big prompt

A spec is a static contract. A workflow is the thing that *runs* it. Hand a forty-step spec to a single agent in one conversation and you're betting the whole job on one long, unbroken chain of attention — and attention is exactly the thing that frays.

Decompose instead. The skill-design rule from the workshop applies to whole workflows: *if one unit is doing five things, split it into five and write a sixth that orchestrates them.* Each stage gets its own narrow slice of the spec, its own guardrails, its own verification — and the orchestrator drives them in sequence. A pipeline of small, verified steps beats one heroic megaprompt every time, because when something fails you know *which* step, you can re-run *just* that step, and every stage carries its own proof forward. This is how a spec stops being a wish and becomes a program: you give it an execution model.

## Surviving the session: implementation plans

Here's the one everybody learns the hard way. Your session **will** end. The context window compacts, the laptop sleeps, you hand the work to a teammate or to tomorrow's you. And if your intent lives only in the conversation, it dies with the conversation. Every `/clear` is a small amnesia.

The fix is the **implementation plan**. Not the spec in your head, not the plan the agent narrated three hours ago — an actual plan written to a file, checked into git, and executed against. The pattern that works: drop into planning mode, have the agent produce a concrete plan from the loaded context, save it, *then* build against it. Now the plan is the spec made resumable. A fresh session reads the plan plus the git state and picks up at the last known-good checkpoint, instead of reconstructing intent from a conversation that no longer exists.

This is the deepest lesson in the whole series, and the workshop put it bluntly: **memory and conversation are unreliable substrates; files and commits are not.** Conversations are RAM — fast, rich, and gone the moment the power blinks. Implementation plans are disk. If you want your intent to outlive the session, you have to write it to disk. The plan *is* the memory.

## Catching the gap: drift detection

Even with guardrails holding the line, a workflow driving each step, and a plan on disk, two kinds of drift creep in — and you have to go looking for both.

The first is **narrative drift**, the long-session trap. Over a long run, an agent develops a *story* about what's happening, and then starts interpreting every new piece of evidence to fit the story instead of updating it. It decided early the bug was in the auth module, and now every log line is "more evidence" for auth — even as the real problem sits untouched in the database layer. The countermeasure is to make the agent argue with itself: for any investigation past ~10 steps, force it to re-state its current hypothesis and list the evidence *for and against* before continuing. Drift loves momentum; this breaks the momentum.

The second is **spec drift** — the gap between what you specified and what actually got built. You asked for six things; it did four and reported "done." Detecting this is a diff, and you can only run the diff because you wrote the spec down in the first place. This is the same point from [The Same Way Twice](/blog/the-same-way-twice/): *you cannot detect drift from a baseline you never established.* The implementation plan is that baseline. Walk the plan against the git history — did every step land? Make the agent report *scope*, not status: not "I updated the config" but "6 of 6 config files matching the pattern, updated." Now "done" is checkable instead of trusted.

## The honest version

This is the layer the other posts assumed and skipped over. [The review is the work](/blog/the-review-is-the-work-now/) — but you can't review what you can't keep on the rails. The spec is the deliverable — but a spec with no enforcement, no execution model, no persistence, and no drift check is just a document slowly diverging from reality.

Orchestration is what makes intent *durable*: guardrails hold the line, the workflow drives the spec, the plan outlives the session, and drift detection keeps the built thing honest against the specified thing. The series opened on the shift from soloist to conductor — and this is the part of conducting nobody romanticizes. The downbeat is easy. Holding eighty musicians to the score for the entire piece, catching the one section that's drifting, and keeping the whole thing together until the final bar — *that's* the job.

So, on your own work: when your session ends tonight, does your intent survive it — written to disk as a plan a fresh agent could resume — or does it evaporate with the context window? I'd genuinely like to hear how people are making intent durable, because I think it's the skill the next few years quietly reward.
