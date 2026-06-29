---
title: 'A Custom G-Eval Grade with a Claude Subagent'
description: "When off-the-shelf metrics don't fit your domain, you stop borrowing someone else's rubric and write your own. Here's how to build a custom G-Eval criterion, use a Claude subagent as the grader, and dodge the four ways an LLM judge quietly lies to you."
pubDate: 'Jun 29 2026'
draft: true
series: 'Ship Confidence'
seriesOrder: 3
tags: ['llm-evaluation', 'ai-testing', 'quality-engineering']
hashtags: ['llmevaluation', 'aitesting', 'agenticdevelopment']
---

Earlier in this series I argued for **Trust but Verify**: you can let an agent do the work, but you don't get to believe the work is good just because the agent says so. The piece I left dangling was the obvious one — *verify how?* For a lot of agentic output there's no green checkmark to wait on. A unit test tells you `2 + 2 == 4`. Nothing built in tells you whether a generated answer was *actually grounded in the source*, or whether a summary *kept the one number that mattered*. Those are judgments, not assertions.

So you reach for a metric. And you discover the metrics on the shelf don't fit your problem.

That's where this post lives: the moment you stop borrowing someone else's rubric and **write your own**. The tool for that is **G-Eval**, and the grader I reach for is a **Claude subagent**.

## What G-Eval actually is

Strip the acronym. **G-Eval is using an LLM as the judge, scoring an output against a written criterion you supply.** That's it. Instead of a regex or an exact-match check, you hand a model a definition of "good" and ask it to grade.

The reason this matters is that most of what agents produce is *open-ended*. There's no single correct string. There's a space of acceptable answers and a fuzzy boundary around it, and the only cheap thing capable of judging that boundary at scale is another language model. The off-the-shelf metrics — relevancy, faithfulness, the standard pack — are themselves G-Eval criteria someone else wrote for the *general* case. They're a fine starting point. They're just not *your* case. Your domain has a definition of "good" that the generic faithfulness metric has never heard of.

The move is the same altitude shift this whole series keeps circling. You're not writing the answer. You're **writing the standard the answer is held to.** Get the standard right and you can grade ten thousand outputs without reading them. Get it wrong and you've automated your own self-deception.

## Writing a criterion that isn't garbage

This is the part everyone underinvests in, and it's the entire ballgame. A vague criterion produces a vague judge, and a vague judge produces a number that *feels* like signal and is actually noise. [Garbage in, gospel out](/blog/garbage-in-gospel-out/) applies to the rubric exactly as hard as it applies to the prompt.

Here's the bad version, the one I see constantly:

> *Score how good and helpful the response is from 1 to 10.*

"Good" how? "Helpful" to whom? Two runs of this against the *same* output will disagree, because you've outsourced the definition to the model's mood. You haven't written a criterion. You've written a vibe.

Here's the rehab. A criterion worth trusting is **specific, observable, and rubber-anchored**.

- **Specific** — name the one thing you're measuring. Not "quality." *"Whether every factual claim in the answer is supported by the provided context."* One axis per metric. If you're measuring three things, write three metrics.
- **Observable** — the judge must be able to *point at evidence* in the output. "Is it well-written" is unobservable hand-waving. "Does it cite a source for each claim" is something a grader can find or fail to find.
- **Rubric-anchored** — define the score band. Don't leave 1-through-5 to interpretation. Say what a 5 looks like, what a 1 looks like, and what the boundary between a 3 and a 4 is.

Lower the criterion onto something more like this:

> *Evaluate whether the output is grounded in the provided context. A claim is "grounded" if it can be directly traced to the context. Score 1.0 only if every claim is grounded. Score 0.0 if any claim is fabricated or contradicts the context. Penalize confident claims that the context does not support more heavily than omissions.*

Notice what that does. It defines the unit ("a claim"), the test ("traceable to the context"), the anchors (1.0 and 0.0), *and* it states a priority — fabrication is worse than omission. Now two runs will agree, because there's almost nothing left to interpret. **The work isn't getting the judge to grade. It's removing every place the judge could improvise.**

## The grader is a Claude subagent

A criterion needs something to run it. My grader is a **Claude subagent** — a separate, single-purpose agent whose only job is to apply that rubric and emit a score plus a one-line reason.

Why a subagent and not just a prompt I paste inline? Two reasons, and they're both about keeping the judge *clean*.

First, **isolation**. The subagent gets its own context window. It sees the criterion, the input, the output to grade — and nothing else. It does not see the conversation that produced the output, it doesn't see your hopes for the result, it doesn't carry the framing that the generating agent was steeped in. That separation is the whole point. The thing being verified and the thing doing the verifying must not share a brain.

Second, **reuse and consistency**. Once it's a defined subagent, every test in the suite invokes the same grader with the same rubric the same way. You're not re-deriving "good" per call. You're maintaining one judge.

Asking for the *reason*, not just the number, is not optional. A bare score is unfalsifiable — you can't tell a correct 0.8 from a lucky one. A score with a one-line justification you can spot-check turns the judge from an oracle into something auditable. Which is the [whole thesis of this series](/blog/the-review-is-the-work-now/): the review is the work, and that includes reviewing your reviewer.

## The four ways your judge lies to you

An LLM judge is a model, and models have failure modes. If you wire one in without knowing them, you've built a confidence machine that confidently reports nonsense. Four to defend against:

**Self-bias.** A model rates output from its own family more generously than a neutral observer would. If the agent that *wrote* the answer and the judge that *grades* it are the same model with the same framing, the judge is grading its own homework. The subagent isolation above is the first defense; using a different model — or at minimum a hard-separated context — is the stronger one. **Never let the author be the sole judge.**

**Vague-criterion drift.** Covered above, but it's the most common failure by a mile. A loose rubric doesn't just produce wrong scores — it produces *inconsistent* ones, which is worse, because the variance hides in the average and you think you have a stable metric.

**Position bias.** When you ask a judge to compare A versus B, it tends to favor whichever came *first* (some models favor the last) regardless of content. If you're doing pairwise grading, run it both ways and average, or you're measuring presentation order, not quality.

**Leniency.** Left to its own instincts, an LLM judge is a soft grader. It wants to be agreeable, so it rounds up. A judge that gives everything a 0.85 is useless — it has no resolution where you need it. Fight this directly: demand evidence for high scores, define the failing band explicitly, and **calibrate against a handful of examples you've hand-graded.** If your known-bad case doesn't score low, your judge is broken, full stop. Test the test.

## Wiring it into the suite

A judge you run by hand once is a party trick. The value is the same as any other check — it runs *every time*, unattended, and fails loud.

So the custom G-Eval metric goes where every other gate goes: in the suite, in CI, with a threshold. The grader subagent is invoked per test case, scores against your criterion, and the run fails if the score drops below the bar you set. Now a regression in grounding fails the build the same way a broken assertion does. You've converted a fuzzy human judgment into a standing, automated gate.

That's the deeper move under "Trust but Verify," and it's the one I want to leave you with. Trust-but-verify, done by a human reading every output, doesn't scale — you become the bottleneck you were trying to remove. **Building the custom judge is how you make the verification itself scale.** You're not the verifier anymore. You're the person who *built* the verifier, wrote its standard, calibrated its bias, and pointed it at the firehose.

Remember the trust pyramid: self-report is the bottom and worthless, and **evidence is the top**. A bare score from a vague judge is just self-report wearing a number costume. A score from a specific, calibrated, isolated judge — with a reason you can audit and a threshold that fails the build — is evidence. That's the whole game. Stop trusting the output. Build the thing that holds it to a standard, and let *that* run while you sleep.
