---
title: 'An Intro to DeepEval'
description: "You decided evals matter. Now you need to actually write one. Here's DeepEval from zero — what a test case is, how metrics judge it, and how to read your first red bar."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1517420704952-d9f39e95b43e'
draft: true
series: 'Ship Confidence'
seriesOrder: 2
tags: ['llm-evals', 'deepeval', 'testing']
hashtags: ['llmevals', 'deepeval', 'aiengineering']
---

In the last post I argued that **evals are the unit tests of the LLM era** — that if you're shipping anything built on a model, the question isn't whether you test it but whether you can prove it still works after the next prompt tweak. That post was the why. This one is the how.

Because "write evals" is the kind of advice that sounds actionable and isn't. It's like telling someone to "get in shape." Okay — starting where? So let me take you from a blank file to a passing (and then a failing) eval, using [DeepEval](https://github.com/confident-ai/deepeval), the open-source framework I reach for. By the end you'll know the shape of a test case, what a metric actually does, and how to read the output without guessing.

## Why DeepEval and not a pile of asserts

You *can* test an LLM with plain `assert` statements. People do. `assert "refund" in output` will even pass sometimes. The problem is that LLM output is non-deterministic and fuzzy: the model might say "I'll process your refund," "your refund is on the way," or "refunding now" — all correct, all different strings, and your substring check fails two times out of three. You end up writing brittle keyword soup that breaks on paraphrase.

DeepEval's bet is that **the only thing good enough to judge fuzzy output is another model.** It's "Pytest for LLMs": same mental model as a normal test suite — test cases, assertions, a runner — but the assertions are **metrics**, and most of the interesting metrics are themselves LLM calls (an LLM-as-judge) that score your output against a rubric instead of matching a string. It plugs straight into Pytest, so it lives in the same `tests/` folder and the same CI job as everything else you already run.

Install is what you'd expect:

```bash
pip install deepeval
export OPENAI_API_KEY=sk-...   # the judge model needs a key
```

That `OPENAI_API_KEY` line matters and trips people up: the **judge** runs on a model, so an eval suite needs its own model access, separate from whatever your app uses. Forget it and your metrics silently collect nothing. (I lost an afternoon to exactly this once — judges built at import time, no key, zero scores, no error.)

## The atom: a test case

![A single specimen clamped in a measuring jig under a bench magnifier, three labeled probe leads touching it — one feeding in, one reading output, one holding a reference card.](/img/intro-to-deepeval/test-case-atom-specimen-jig.png)

Everything in DeepEval orbits one object — the **test case**. Strip away the framework and a test case is three fields:

```python
from deepeval.test_cases import LLMTestCase

test_case = LLMTestCase(
    input="Can I get a refund for an order I placed yesterday?",
    actual_output="Yes — orders within 30 days are eligible. I can start that now.",
    expected_output="Confirm eligibility (within 30 days) and offer to process it.",
)
```

Read those three fields slowly, because they're the whole game:

- **`input`** — what you sent the system. The prompt, the user turn, the question.
- **`actual_output`** — what your system actually produced. This is the thing under test. You generate this by *calling your real app* — your agent, your chain, your endpoint — not by hand.
- **`expected_output`** — what good looks like. Optional, and notice it's a *description of correct behavior*, not a string to match exactly. Some metrics use it; some don't need it at all.

There are richer fields for richer systems — `retrieval_context` for RAG (the chunks your retriever pulled), `context` for ground truth, `tools_called` for agents — but `input` / `actual_output` / `expected_output` is the irreducible core. If you understand this object, you understand DeepEval. Everything else is metrics judging this object.

One thing worth saying out loud: **DeepEval does not call your app for you.** You produce `actual_output` yourself and hand it in. That's a feature — it means DeepEval works no matter how weird your stack is. It only cares about the text that came out.

## Metrics: the assertion that thinks

![A litmus test strip lifted from a sample, its color band aligning against a printed 0-to-1 scale card, with a small handwritten note beside it — a score that also gives a reason.](/img/intro-to-deepeval/metric-litmus-score-with-reason.png)

A test case on its own asserts nothing. You need a **metric** to render a verdict, and the metric is where DeepEval earns its keep. Each metric takes a test case, produces a **score between 0 and 1**, compares it to a **threshold** you set, and passes or fails — plus, crucially, it gives you a **reason** in plain English.

The built-in metrics cover most of what you'll want on day one:

- **Answer Relevancy** — does the output actually address the input? (Catches confident, on-brand non-answers.)
- **Faithfulness** — for RAG: is the output grounded in the retrieved context, or did the model invent things? (This is your hallucination detector.)
- **Contextual Relevancy / Precision / Recall** — is your *retriever* even handing the model the right material?
- **[G-Eval](https://deepeval.com/docs/metrics-llm-evals)** — the swiss-army knife: define your *own* criterion in a sentence and let an LLM judge it.

Wiring one up is three lines:

```python
from deepeval.metrics import AnswerRelevancyMetric

metric = AnswerRelevancyMetric(threshold=0.7)
metric.measure(test_case)

print(metric.score)    # e.g. 0.92
print(metric.reason)   # "The output directly confirms refund eligibility and offers next steps."
```

That `reason` field is the difference between an eval suite you trust and one you ignore. A red bar that just says `0.41 < 0.7` tells you that you failed; the reason tells you *why* — "the output never addressed the timeframe the user asked about" — which is the part you can actually act on.

## When the built-ins don't fit: G-Eval

The built-in metrics are generic on purpose. Your product isn't. Sooner or later you need to assert something specific — "the response must never promise a refund without confirming the order date," or "the tone must stay professional," or "it must cite a policy number." That's **G-Eval**: you write the criterion in English and DeepEval turns it into a scored LLM judge.

```python
from deepeval.metrics import GEval
from deepeval.test_cases import LLMTestCaseParams

correctness = GEval(
    name="Refund Correctness",
    criteria="Determine whether the actual output confirms refund "
             "eligibility based on the 30-day window before offering to process it.",
    evaluation_params=[LLMTestCaseParams.INPUT, LLMTestCaseParams.ACTUAL_OUTPUT],
    threshold=0.7,
)
```

This is the move that takes you from "I'm running someone's generic relevancy check" to "I'm encoding *my* definition of correct." Most mature suites I've seen are a handful of built-ins plus a small, growing pile of G-Eval metrics that read like a spec written in sentences. Which, pleasingly, they are — the same point I keep circling back to in [Context Is King](/blog/context-is-king/): the clearer you state intent, the better the machine does the job.

## Running a suite and reading the result

One test case is a demo. A *suite* is the point. DeepEval gives you two ways to run, and you'll use both.

For quick local iteration, `evaluate()` runs a list of cases right in a script:

```python
from deepeval import evaluate

evaluate(test_cases=[test_case], metrics=[metric, correctness])
```

For CI — the place evals actually pay off — you write them as Pytest functions and let DeepEval's `assert_test` do the failing:

```python
from deepeval import assert_test

def test_refund_flow():
    assert_test(test_case, [metric, correctness])
```

Then `deepeval test run test_refunds.py`, and you get a results table: each case, each metric, the score, the threshold, pass or red. A failure looks like this in spirit:

```
✗ test_refund_flow
  AnswerRelevancyMetric: 0.91 (threshold 0.7) ✓
  Refund Correctness:    0.48 (threshold 0.7) ✗
    reason: Output offered to process the refund but never
            confirmed the order fell within the 30-day window.
```

That is the entire payoff of the post. You didn't get "the model seems worse today." You got a named case, a specific metric, a number under a line, and a sentence telling you the model is skipping the eligibility check. That's a regression you can hand to someone — or to an agent — and say *fix this*. It's the difference between a vibe and a ticket.

## Where to start tomorrow

Don't build the perfect harness. Build the smallest real one:

- **Write five test cases**, not five hundred. Pick the five interactions that would most embarrass you if they broke. Real inputs, real outputs from your actual app.
- **Start with one built-in metric.** Answer Relevancy if you're doing chat, Faithfulness if you're doing RAG. Set the threshold honestly, not aspirationally.
- **Add one G-Eval** that encodes the single rule your product can't violate.
- **Wire it into CI** so it runs on every change. An eval that only runs when you remember it is a vibe with extra steps.

That's it. Five cases, two metrics, one CI job — and you've crossed the line from hoping the model still works to *checking* that it does. The first time a prompt change you were sure was harmless turns a bar red, you'll understand why I won't ship without these anymore.

This is also the unglamorous half of a habit I've written about before — [trust, but verify](/blog/trust-but-verify/). The model is the trust. The eval is the verify. And the reason it's worth the setup is the same reason it's worth pinning a model version: you want the system to behave [the same way twice](/blog/the-same-way-twice/), and the only way to know it does is to measure it.

Next in the series: going past one-shot metrics into datasets, regression baselines, and judging agents that take multiple steps. But you don't need any of that yet. Go write the five.
