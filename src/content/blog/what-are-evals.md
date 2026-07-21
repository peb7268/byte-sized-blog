---
title: 'What Are Evals?'
description: "The gap between 'it worked when I tried it' and engineering has a name: evals. They're repeatable, measured tests of an AI system's output quality — and they're the difference between shipping on confidence and shipping on hope."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1559819614-8e87b90b8e9b'
draft: false
series: 'Ship Confidence'
seriesOrder: 1
tags: ['evals', 'ai-quality', 'engineering-discipline']
hashtags: ['evals', 'aiengineering', 'shipconfidence']
---

Here's a sentence I've said, and I'd bet you have too: *"Yeah, I tested it — it worked when I tried it."*

It's a lie. Not a malicious one. But when the thing you built is an AI system — a prompt, an agent, a classifier, a pipeline that takes natural language in and produces something out — "it worked when I tried it" is one of the least trustworthy claims in software. You ran it once, maybe three times, on inputs you happened to think of, and the output looked good to you in the moment. That's not a test. That's a **vibe.**

And vibes are exactly how most AI systems are shipped right now.

I want to draw a hard line in this series, and this post is where I draw it. On one side: vibes — spot-checking, eyeballing, "looks right to me." On the other side: **evals** — repeatable, measured tests of an AI system's output quality. The whole point of this mini-series is to move you from one side of that line to the other. So before anything else, let's be precise about what's actually on the other side.

> An eval is a repeatable test that measures the quality of an AI system's output. Inputs go in, you define what a good answer looks like, something grades the result, and you get a **score you can track over time.** That's it. That's the whole idea. Everything else is detail. It's like an **e2e** test you wrote for agentic output.

## Why "it worked when I tried it" silently rots

The problem with spot-checking isn't that it's wrong. It's that it doesn't scale, and worse, it *degrades without telling you.*

Think about what you actually do when you manually check AI output. You run the system on a handful of inputs — the ones top of mind, which are almost always the easy, central cases. You read the output. You decide it's fine. Three failure modes are baked into that loop, and every one of them is invisible from the inside:

- **You test the inputs you think of, not the ones that break it.** Your mental sample is biased toward the cases you already understand. The edge cases — the empty input, the adversarial phrasing, the weird Unicode, the one customer with a name that's also a SQL keyword — those are exactly the ones you don't think to try, because if you'd thought of them you'd have handled them.
- **"Looks right" is not "is right."** AI output is *designed* to look plausible. That's the whole technology. A confidently wrong answer and a correct one are visually indistinguishable until you check against something real. Skimming output and nodding is the single easiest way to ship a bug, because the bug is wearing a nice suit.
- **It doesn't survive change.** You tweak the prompt to fix one case. Did you just break four others? You have no idea, because re-checking by hand is tedious and you've got other work. So you don't. You change one line and pray.

That last one is the killer. An AI system isn't static — you're constantly nudging the prompt, swapping the model, adding a tool, tightening an instruction. Every one of those changes can silently regress behavior you fixed last week. Manual checking can't catch silent regression, because by definition you're not looking. The system **rots,** and the first time you find out is when a user does — [exactly what happened when Anthropic's own evals missed a real degradation users were reporting](https://www.anthropic.com/engineering/a-postmortem-of-three-recent-issues).

This is the same disease I wrote about in [The Review Is the Work Now](/blog/the-review-is-the-work-now/) — except there the failure was a human rubber-stamping AI output instead of engaging with it. Here it's a human rubber-stamping their *own* AI system instead of measuring it. Same root cause: confusing "I looked at it" with "I verified it."

## What an eval actually is

![A QA inspection station on a workbench — raw samples entering, a spec card clipped above, an inspection arm, and a single lit numeric readout at the end.](/img/what-are-evals/eval-four-part-inspection-bench.png)

Strip away the tooling and the jargon, and an eval has exactly four parts. If you can name these four, you understand evals better than most people shipping AI features today.

**1. Inputs.** A set of cases you run the system against. Not one — a *set.* Ten, a hundred, a thousand. And crucially, a set you *curate on purpose* to include the easy cases, the edge cases, and the ones that have burned you before. This is your test corpus, and it's the thing that grows every time production surprises you.

**2. Expected qualities.** What does a good output look like for each input? Sometimes this is a single correct answer — "the model should classify this email as spam." Often it's fuzzier — "the summary should be under 100 words, mention the refund, and not invent a policy that doesn't exist." Either way, you write the standard *down,* explicitly, before you look at the output. Stating the invariant up front is what stops you from grading on a curve after the fact.

**3. A grader.** Something that compares the actual output to the expected qualities and produces a verdict. This is the part people don't realize they have options for. A grader can be a dead-simple string match or regex. It can be code that parses the output and checks structure. It can be an assertion against a known answer. And — the move that unlocks the fuzzy cases — it can be *another LLM acting as a judge,* scoring the output against a rubric you wrote. (That last one, the LLM-as-judge, gets its own post in this series, because it's powerful and full of sharp edges.)

**4. A score.** The grader's verdicts roll up into a number. 84 out of 100 passed. The summarizer scores 0.91 on faithfulness. Whatever the shape — the point is it's a **number you can write down, compare, and watch move.** Last week you were at 78. You changed the prompt. Now you're at 91. *That's* progress you can defend. Or: now you're at 64, and you just learned your "improvement" was a regression — before it reached a user.

Inputs, expected qualities, a grader, a score. That's an eval. Notice what it gives you that spot-checking never can: a number that holds still so you can tell whether your changes are making things better or worse.

## The mindset shift: from QA to a number that holds still

![A balance scale with a translucent, wispy 'feeling' cloud on one pan and a solid engraved metal number tile on the other — the number pan resting firmly down.](/img/what-are-evals/vibe-vs-number-balance.png)

The mechanics are simple. The mindset is the hard part, because it asks you to give up something comfortable.

Vibes are *fast and flattering.* You run it, it looks good, you feel good, you ship. Evals are slower up front and occasionally humbling — sometimes the number tells you your clever prompt is worse than the dumb one. People resist evals for the same reason they resist code review and tests: it converts a private feeling of "this is good" into a public number that can disagree with you.

But that's the entire value. This series is called **Ship Confidence** for a reason, and I want to be exact about what I mean: confidence isn't the feeling that it'll probably work. Confidence is *evidence that it works,* sitting in a number you can point at. The feeling is hope. Hope is not a strategy for software that talks to your customers.

This is the same instinct behind [Trust but Verify](/blog/trust-but-verify/) — never let a claim float on assertion when you can pin it to evidence. An eval is just that principle made mechanical for AI output: it takes "the model is good at this" and forces it down to "the model scores 0.89 on this, here's the run." And it's the same instinct behind [The Same Way Twice](/blog/the-same-way-twice/) — a test you can't repeat isn't a test. An eval is, before anything else, a *repeatable* measurement. Run it today, run it next month after you swap models, get a comparable number. Without repeatability there's no trend, and without a trend you can't tell rot from progress.

## Where this series goes

So that's the foundation. An eval is a repeatable, measured test of output quality: **inputs → expected qualities → a grader → a score you track.** It's how you stop saying "it worked when I tried it" and start saying "it scores 91, up from 78, here's the run."

From here the series gets concrete. We'll build a real eval from nothing. We'll dig into graders — when a regex is plenty and when you need an LLM judge, and how to keep that judge honest. We'll talk about building the input corpus that actually catches your failures instead of flattering you, and about wiring evals into CI so the rot gets caught by a machine instead of a customer.

But none of it matters if you don't internalize the line drawn here. Spot-checking feels like testing and isn't. The cure isn't checking *harder* by hand — it's checking *measurably,* once, in a way that repeats. Trade the vibe for the number. Ship confidence, not hope.
