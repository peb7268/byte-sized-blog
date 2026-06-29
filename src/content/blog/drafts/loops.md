---
title: 'Loops'
description: "The one-shot prompt is the training wheels of agentic work. The real leverage is the standing loop — a job that runs on an interval or runs until a condition is met, working while you don't."
pubDate: 'Jun 29 2026'
draft: true
series: 'The New Ways of Working'
seriesOrder: 3
tags: ['agentic-ai', 'automation-patterns', 'agent-loops']
hashtags: ['agenticdevelopment', 'aiengineering', 'automation']
---

Most people are still using agents like a vending machine. You walk up, put in a prompt, get a thing back, walk away. One question, one answer, done. It works, and because it works, almost nobody asks the next question: what if I didn't have to walk up?

That's the whole shift I want to talk about. The one-shot prompt is the training wheels of agentic work — useful, real, and a fraction of what these things can do. The leverage isn't in asking better questions faster. It's in setting up a **standing loop**: a job that runs on its own — on an interval, or until some condition is met — and works while you're asleep, in a meeting, or three problems downstream.

I've started thinking about this as the difference between *asking* an agent and *deploying* one. And once you've deployed one, you don't really go back.

## The two shapes of a loop

Strip away the framing and there are only two kinds of loop worth knowing, and they split on a single question: **what stops them?**

A **recurring loop** runs on a clock. Every five minutes, every hour, every morning at 6am — it wakes up, does its thing, goes back to sleep. Nothing about the work itself ends the loop; *you* end it, or the schedule does. This is the right shape when the world keeps changing and you want to keep noticing.

A **self-paced loop** runs until a condition is true. "Keep retrying until the build is green." "Keep refining until the test suite passes." "Keep accumulating until you hit the target." The loop owns its own exit. It's not watching a clock; it's watching a goal, and it stops the moment the goal is met (or, importantly, when it gives up).

Almost everything useful is one of those two, sometimes nested — a recurring loop on the outside that kicks off self-paced loops on the inside. Get the shape right and the rest is plumbing.

## When a loop genuinely beats a one-off

I want to be honest here, because the failure mode at the other end of this is wrapping a `while` around things that should have stayed a single call. A loop earns its keep in four specific situations.

**Monitoring.** The state you care about lives somewhere else and changes without telling you — a deploy pipeline, a queue, a remote service, an inbox. A one-shot prompt gives you a snapshot. A recurring loop gives you a *watch*. "Check the deploy every five minutes and ping me when it's done or broken" is not a fancier version of "is the deploy done?" — it's a different category of thing, because it removes you from the polling entirely. You stop being the cron job.

**Retries.** Some work fails for reasons that go away on their own — a flaky network, a rate limit, a service that's briefly down. A self-paced loop with a sane backoff turns "it failed, try again later" into something the agent just *handles*. The condition is success; the loop runs until it gets there or hits its ceiling.

**Accumulation to a target.** This is the one people miss. Some jobs aren't done in one pass by design — collect leads until you have fifty, summarize files until the whole directory's covered, generate variations until one clears the bar. The loop's exit is a *quantity* or a *quality threshold*, and each iteration moves you closer. You're not asking "do it"; you're asking "keep doing it until it's enough."

**The overnight grind.** This is my favorite, because it's pure found time. Long, boring, parallelizable work — migrate a hundred files, backfill a dataset, churn through a refactor module by module — set it running before you close the laptop and review what it produced in the morning. The constraint stops being *can the agent do it* and starts being *can you trust what it did.* Which is the whole point of the series, and exactly why [the review is the work now](/blog/the-review-is-the-work-now/): the loop generates while you sleep, and your judgment is what greets it at sunrise.

## The self-improving loop

There's one pattern that deserves its own section, because it's where loops stop being convenient and start being genuinely powerful: the cycle that grades its own work.

**Run → evaluate → adjust → re-run.**

The agent does the thing. Then it checks the thing against a standard — a test suite, a metric, a rubric, a smell test. If it falls short, it adjusts and goes again. The evaluation step is the magic ingredient, because without it you don't have a self-improving loop, you have an agent confidently producing the same wrong answer five times.

This is the difference between a loop that converges and one that just *spins*. A loop with a real evaluation gate gets closer to right on each pass. A loop without one gives you volume and calls it progress. If you've read [the same way twice](/blog/the-same-way-twice/), you already know why I distrust the second kind: repetition isn't reliability. A loop that can't tell good output from bad doesn't get more reliable the more it runs — it gets more *expensive*.

So the engineering question for any self-improving loop is never "can it iterate?" It's "what's the judge, and do I trust the judge?" Build the judge first. The loop is easy; the judge is the work.

## The failure modes, told straight

I'm not going to sell you loops without the warning label, because the warning label is the difference between leverage and a bill you didn't expect.

**Runaway loops.** A loop with a bad exit condition — or no exit condition — doesn't fail loudly. It just keeps going. The self-paced loop whose success condition can never be met will retry forever. The recurring loop you forgot to turn off will still be running next month. Every loop needs an answer to "what stops this, and when?" written down *before* it starts, not discovered after.

**Cost.** Every iteration costs tokens, and a loop is iterations by definition. A one-shot prompt is a known quantity; a loop is a *rate*. The overnight grind that felt clever can hand you a number in the morning that does not feel clever at all. The fix is boring and non-negotiable: **budgets**. Cap the iterations. Cap the spend. Cap the wall-clock time. A loop without a ceiling is a leak.

**No guardrails.** Speed without oversight is just a faster way to be wrong at scale. A loop that takes destructive actions — writes files, sends messages, moves money — needs limits on *what* it can do, not just *how long* it can do it. The blast radius of a one-shot mistake is one mistake. The blast radius of a looping mistake is one mistake times however many times it ran before anyone looked.

The throughline: a loop multiplies whatever you point it at. Point it at something good and bounded, and it's the best leverage in the toolkit. Point it at something vague and uncapped, and it multiplies that too.

## The mental model

Here's the reframe I want to leave you with. A one-shot prompt is you doing the work with a faster tool. A loop is you **building the thing that does the work** — and then stepping back. That's the same altitude shift the whole series keeps circling: you stop being the one in the loop and start being the one who *designs* it. It's the natural sibling of [orchestration](/blog/orchestration/) — orchestration is many agents working together in space; loops are one agent working across time.

The skill isn't writing the loop. Writing the loop is trivial. The skill is knowing which of the two shapes fits, what condition stops it, who judges its output, and where the budget caps out. Get those four right and you've got an employee that works the night shift for the price of an API call.

Stop walking up to the vending machine. Build the thing that walks up for you — and then go do something else.
