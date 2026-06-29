---
title: 'How Evals Enable Self-Improving Harnesses'
description: "Evals don't just catch regressions — they turn a harness into a system that gets better on purpose. Here's the empirical loop that compounds measurement into a flywheel, and why without it every change is a guess."
pubDate: 'Jun 29 2026'
draft: true
series: 'Ship Confidence'
seriesOrder: 4
tags: ['evals', 'self-improving-systems', 'agentic-ai']
hashtags: ['evals', 'agenticdevelopment', 'aiengineering']
---

This is the post the rest of the series was building toward.

I've spent the last three posts arguing that you can't trust an agentic harness you don't measure — that evals are how you know a change helped instead of *feeling* like it helped, and that a locked baseline is the only honest answer to "is it better than yesterday?" All true, all necessary. But measurement for its own sake is just bookkeeping. The reason to do any of it is the thing I want to make concrete now:

> Once you can measure a harness, you can *improve it on purpose* — not by intuition, not by vibes, but by a loop that compounds. Evals are what turn a static tool into a system that gets better every time you run it.

That loop is the whole payoff. Let me describe it, then tell you why it's harder and more valuable than it sounds.

## The loop, stated plainly

A self-improving harness runs on five steps, in order, forever:

1. **Eval.** Run the harness against a fixed set of cases and score the output.
2. **Find the failures.** Read where it fell down — not the aggregate number, the actual failed cases.
3. **Strengthen the weak link.** Change exactly one thing: tighten a piece of context, add a rule, rewrite a prompt, swap in or out an agent.
4. **Re-eval.** Run the same fixed cases again.
5. **Compare and decide.** Did the score move up, down, or not at all? Keep the change or throw it out. Then repeat.

That's it. There's nothing clever in any single step. The power is entirely in the loop closing — in step 5 feeding back into step 1 with a number you can trust. Break the loop anywhere and you're back to guessing.

I called this idea, in an earlier post, "treat each run as an empirical signal." This is that idea made rigorous. The difference between a developer who *believes* their harness is improving and one who *knows* it is, is whether step 4 exists. Everything else is the same energy. The eval is what makes the belief checkable.

## Without evals you're guessing — and you'll guess wrong

I want to dwell on this because it's the part people underrate.

Say your harness produces a bad plan. You look at it, you have a theory — "the agent didn't have the module's conventions in context" — and you add the conventions doc. The next plan looks better. Did your change help?

You have no idea. You changed one input and observed one output. Maybe the doc helped. Maybe that ticket was just easier. Maybe the model rolled differently this time. Maybe you *also* fixed a typo in the prompt while you were in there and that's what actually moved it. With a sample size of one and no control, "it looks better" is indistinguishable from luck.

This is the trap I wrote about in [trust but verify](/blog/trust-but-verify/) — the output that *looks* right is the most dangerous kind, because it buys your confidence without earning it. A harness change that looks like an improvement is the same hazard one level up. You ship it, you move on, and you never learn it did nothing — or worse, that it helped case A and quietly broke case B.

Evals are the antidote because they hold everything else still. Same cases, same scoring, the only variable is the change you made. Now "the score went from 71 to 78" is a fact, not a feeling. And "the score went from 71 to 68" is the more valuable fact, because it stops you from shipping a regression you'd have sworn was an upgrade. You cannot get that signal from staring at one run. You can only get it from a loop.

## What "strengthen the weak link" actually means

Step 3 is where the craft lives, so it's worth being concrete about the moves available. When an eval surfaces a failure, the fix is almost always one of four things:

- **Context.** The agent didn't have what it needed, or had too much and drowned the signal. You tighten what gets loaded. (This is the entire subject of the foundations work — the folder was wrong.)
- **Rules.** The agent had the material but made a judgment call you don't want it making. You add an explicit invariant so the call isn't left to chance.
- **A prompt.** The instruction was ambiguous, or buried, or asked for the wrong shape of output. You rewrite it.
- **An agent.** The task is being handled by the wrong specialist, or by one generalist doing three jobs. You add a dedicated agent, or replace one that's underperforming, or split a role in two.

The discipline — and it is a discipline — is **changing one of these at a time.** The temptation, every single time, is to fix the failed case by adjusting the context *and* the prompt *and* tweaking the rule, all in one pass, because you can see all three problems at once. Don't. If you change three things and the score moves, you've learned that *something* helped and nothing about *what*. You've spent a measurement and bought no knowledge. One change, one re-eval, one verdict. It feels slow. It's the only thing that actually compounds.

## The flywheel: why measurement compounds

Here's the part that makes this worth the setup cost. Each turn of the loop doesn't just fix a case — it *ratchets*. Because the baseline is locked, every improvement you keep becomes the new floor. You can't accidentally give it back later, because the next regression that would erase it gets caught by the same eval that caught the original failure.

So the gains accumulate instead of sloshing around. Turn one takes you from 71 to 78 and locks 78 in. Turn two builds on 78, not on 71. A normal workflow without this loop oscillates — you fix a thing, something else drifts, you fix that, the first thing breaks again, and a year later you're roughly where you started but exhausted. The eval loop is what converts that oscillation into a climb. The locked baseline is the ratchet tooth that stops the backslide.

That's the flywheel. It's slow to start — building the eval cases is real work, and the first few turns feel like overhead with no payoff. But once it's spinning, each turn is cheaper than the last, because the harness is steadily getting better at the cases you care about and you're getting faster at reading the failures. Measurement compounds into momentum. That's the thing you can't buy any other way.

## The two pieces of discipline that hold it together

The loop is simple to draw and easy to corrupt. Two habits keep it honest.

**Lock the baseline, and treat it as sacred.** A baseline you quietly re-record every time the score dips isn't a baseline — it's a mood ring. The whole value is that it doesn't move unless you *decide*, deliberately and on the record, that the new behavior is the correct one. I've watched well-meaning people defeat their own eval suite by rebaselining the instant red appeared, which is exactly like deleting the failing test to get a green build. The baseline only protects you if you let it tell you things you don't want to hear.

**Gate on regressions.** An eval that runs but doesn't *block* is a smoke detector you've taken the battery out of. The point of the suite is that a change which drops the score below baseline doesn't merge — full stop, no override-because-I'm-in-a-hurry. This is the same standard I argued for in [the review is the work now](/blog/the-review-is-the-work-now/): the verification isn't the overhead around the work, it *is* the work, and a gate is how you stop yourself from skipping it under pressure. Make the loop refuse to close on a regression and the harness can't quietly rot while you ship.

Those two together — a baseline that doesn't flinch and a gate that doesn't bend — are what separate a real self-improving system from a dashboard nobody looks at.

## Where this leaves the series

Pull the thread all the way back. [Doing it the same way twice](/blog/the-same-way-twice/) gave us repeatability — the precondition for measuring anything at all, because you can't compare runs that were never comparable. [Orchestration](/blog/orchestration/) gave us a harness worth measuring — agents and context assembled into a system with parts you can name and swap. This post is what those two were *for*: a harness that's both repeatable and modular is a harness you can put in a loop and improve on purpose.

That's the reframe I'll leave you with. We tend to think of evals defensively — as a net that catches regressions, a chore you do to avoid shipping bugs. The net matters. But the bigger thing is that the same machinery, pointed forward instead of backward, is an *engine*. Every failure the eval surfaces is a coordinate telling you exactly where the next improvement lives. Every passing run that holds the line is a gain you get to keep.

Without evals, you have a harness you hope is getting better. With them, you have one that demonstrably is — turn after turn, on purpose, forever. That's not a testing strategy. That's a flywheel. Build it, lock it, gate it, and let it spin.
