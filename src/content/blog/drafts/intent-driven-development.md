---
title: 'Intent-Driven Development'
description: "I've written a series on how to spec and a series on how to eval. This is the post where I admit they were never two skills. A spec is your intent declared; an eval is the contract that proves it. Do both on purpose and you have a method — Intent-Driven Development."
pubDate: 'Jul 22 2026'
# heroImage: TBD — blueprint + inspection-stamp motif; pull themed Unsplash on publish
draft: true
series: 'Agentic Engineering'
seriesOrder: 12
tags: ['agentic-development', 'intent-driven-development', 'specs', 'evals']
hashtags: ['agenticdevelopment', 'aiengineering', 'intentdrivendevelopment']
socialQuote: "A spec is intent stated forward. An eval is the same intent made falsifiable. IDD is what you call it when you write both on purpose."
---

I've spent one series teaching you [how to write a spec](/blog/anatomy-of-a-spec/) and another teaching you [how to write an eval](/blog/what-are-evals/). I let you believe those were two different skills you'd pick up on two different days. They aren't. They're the same skill, seen from opposite ends — and this is the post where I connect the two wires and give the thing its name.

The name is **Intent-Driven Development.** IDD. And the whole idea fits in one sentence:

> A spec is your intent, declared. An eval is your intent, proven. The spec says what should be true; the eval is the contract that holds you to it. Write both, on purpose, and the agent fills the middle.

Everything below is the argument for why those two artifacts are actually one, and why treating them as one is the method that survives contact with real agentic work.

## Two documents, one source

Watch what you actually do when you brief an agent well.

First you write down what you want — the outcome, the reason it matters, the inputs, the invariants, the [non-goals](/blog/anatomy-of-a-spec/) that close the doors you don't want it wandering through. That's the spec. It points *forward*: here is the thing that doesn't exist yet, described precisely enough to bring it into being [the same way twice](/blog/the-same-way-twice/).

Then — if you're disciplined — you write down how you'll *know* it worked. Concrete cases, expected qualities, a grader, a threshold. That's the eval. It points *backward*: here is the finished thing, measured against what I claimed I wanted.

Now look at those two documents side by side and notice the uncomfortable thing. **They're describing the same object.** The spec is that object stated as a promise. The eval is that object stated as a test. One source of truth — your intent — projected onto two surfaces. If you wrote them both honestly they should say the same thing in two grammars: the imperative ("do this") and the interrogative ("did it?").

That's the move IDD asks you to make consciously: stop treating "write the spec" and "write the evals" as separate chores at separate times, and start treating them as two required projections of a single act of deciding what you want.

## Each half is useless without the other

The fastest way to see that spec and eval are one thing is to try to keep just one of them.

**A spec with no eval is a wish with good grammar.** You wrote down, beautifully, what "good" means — and then you never checked. So the agent does the thing, it *looks* right (AI output is [engineered to look right](/blog/what-are-evals/)), and you nod it through. This is exactly the disease from [Trust but Verify](/blog/trust-but-verify/): a claim of "it works" floating free of any evidence. A spec without an eval is intent you declared and then declined to defend. The silences in the spec are where the agent improvises, and with no eval you have no idea which improvisations went sideways until a user tells you.

**An eval with no spec is a grader pointed at nothing.** You have cases and a threshold, but where did the threshold come from? If you wrote the eval *after* the system — bolted it on to whatever behavior you happened to get — it encodes the output you got, not the outcome you wanted. That's the [contaminated, written-to-be-green test](/blog/eval-driven-development/) I warned about in EDD. A number with no north star. It moves, and you can't say whether up is good, because "good" was never written down anywhere the grader could see it.

Put them together and each one repairs the other's failure. The spec gives the eval its *meaning* — the threshold now stands for something you decided on purpose. The eval gives the spec its *teeth* — the intent can no longer float free, because there's a contract that fails loudly when reality drifts from the promise. Neither is complete alone. That's not a coincidence you can optimize away; it's the tell that they were one thing the whole time.

## The gap between them is the most valuable signal you have

Here's the part that makes IDD more than a tidy renaming.

When you write the spec and the eval as two separate expressions of the same intent, they will sometimes **disagree.** Your spec will promise something your eval doesn't check. Your eval will reward something your spec never asked for. And every one of those disagreements is a place where *you did not actually know what you wanted* — you just hadn't noticed yet.

That is gold. It's the cheapest bug you'll ever fix, because you catch it in the two documents, before the agent has written a line, before a user has hit the edge case. A spec clause with no matching check is an **orphan intent** — a promise nobody's enforcing. An eval case with no matching spec clause is an **orphan check** — a rule you're grading on that you never committed to. IDD, done as a practice, is largely the work of driving both orphan counts to zero: every intent has a proof, every proof traces to an intent.

![A drafting table with two translucent sheets overlaid on a lightbox — a blueprint on top, an inspection checklist beneath — most lines registering perfectly, and three lines glowing red where the two sheets fail to line up.](/img/intent-driven-development/spec-eval-overlay-gap.png)

If you've ever written a spec and *then* written its evals and felt the small, annoying friction of "wait, what should this actually score here?" — that friction was the method working. That was a gap surfacing. The undisciplined move is to smooth it over by making the eval agree with the spec you already wrote. The IDD move is to stop and ask which of the two documents is actually right, because you just learned your intent was blurrier than you thought.

## The loop

IDD runs the same shape as [eval-driven development](/blog/eval-driven-development/), widened to hold both halves explicitly:

1. **State the intent as a spec.** Outcome, reason, inputs, invariants, non-goals. Forward-facing. This is what should be true.
2. **Encode the same intent as an eval.** Cases, expected qualities, grader, threshold. Backward-facing. This is how we'll know.
3. **Reconcile the two.** Walk the orphans. Every spec clause needs a check; every check needs a clause. The disagreements are free bugs — fix them here.
4. **Let the agent fill the middle.** The implementation is the part you [delegate](/blog/intelligence-moves-up-the-stack/) now. You own the two ends; the machine owns the span between them.
5. **Score, read the failures, iterate.** A red eval is [coordinates, not a verdict](/blog/evals-self-improving-harnesses/). The gap between intended and actual is where the next change goes — in the system, or, just as often, in your understanding of what you meant.

Notice who does what. The human writes intent — twice, forward and backward. The agent writes code. That division is the whole reason this scales: you've moved yourself entirely up to the layer of *what and whether*, and handed *how* to something that's very good at how.

## Why this is the unit of agentic work now

The leverage in software [moved up the stack to intent](/blog/intelligence-moves-up-the-stack/). Capability got cheap; the implementation is a commodity a model produces on demand. What stayed scarce — what's *more* scarce than ever — is a clear intent, expressed rigorously enough to both **instruct** a build and **verify** it.

Those two verbs are the spec and the eval. Instruct forward, verify backward. IDD is just the discipline of noticing that they're the same intent and refusing to do one without the other. Spec-writing taught you to instruct. Eval-writing taught you to verify. They were never two methods. They were one method wearing two hats, and now it has a name.

Write the intent. Prove the intent. Let the machine do the middle.
