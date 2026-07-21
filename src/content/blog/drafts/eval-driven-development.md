---
title: 'Eval-Driven Development'
description: "TDD said: write the test first, then the code that passes it. EDD says the same thing one level up — write the eval first, then build the AI system that scores against it. Here's the discipline, and why Meta's just-in-time testing is the same idea arriving from the other direction."
pubDate: 'Jul 21 2026'
draft: true
series: 'Ship Confidence'
seriesOrder: 5
tags: ['evals', 'edd', 'test-driven-development', 'agentic-ai']
hashtags: ['evals', 'aiengineering', 'shipconfidence']
---

Test-driven development had one genuinely radical idea buried inside all the ceremony: **write the check before you write the thing.** Not after, when you're tired and generous and looking for reasons to call it done — before, when the check is still an honest statement of what "working" means. The test comes first, it fails, and then you write exactly enough code to make it pass.

This series has spent four posts arguing that AI systems need the same kind of measurement that unit tests gave code — [a number that holds still](/blog/what-are-evals/) instead of a vibe. This post is the one where I name the practice that falls out of taking that seriously, and it has a predictable name: **eval-driven development.** EDD. TDD's idea, moved up one level to the layer where the output is fuzzy and the grader is another model.

> Write the eval first. Watch it fail. Then build the prompt, the context, the agent — whatever the system is — until the eval passes. The eval is the spec; the score is the definition of done.

That reordering is the whole thing. And like TDD, it sounds like bureaucratic overhead until the first time it saves you from shipping something you were *sure* was fine.

## What "eval first" actually changes

Most people build an AI feature in the obvious order: write the prompt, try it on a couple of inputs, eyeball the output, ship. The eval — if it ever exists — gets bolted on afterward, and by then it's contaminated. You write it to pass the system you already built, which means it encodes the behavior you happened to get, not the behavior you actually wanted. It's a test written to be green. It tells you nothing.

EDD forces the honest order. Before you touch the prompt, you write down — as cases, as a rubric, as a [G-Eval criterion](/blog/custom-geval-claude-subagent/) — what a good answer looks like. Concrete inputs, expected qualities, a grader, a threshold. You run it against whatever you have (nothing, or a naive first draft) and it fails. *Now* you build, and every change you make is measured against a target you set while you were still being honest.

This is exactly the discipline from [Trust but Verify](/blog/trust-but-verify/), turned into a workflow: never let the claim "it works" float free of the evidence. In EDD the evidence exists *before* the work does. You can't grade on a curve after the fact because you already drew the line.

## The loop

EDD runs the same five-beat loop as the [self-improving harness](/blog/evals-self-improving-harnesses/), just pointed at a feature you're building rather than a harness you're maintaining:

1. **Write the eval.** Cases + expected qualities + grader + threshold. This is the spec, expressed as something executable.
2. **Run it. Watch it fail.** A red bar you understand is the starting line.
3. **Build the smallest thing** that could move the score — a prompt, a context change, a rule, an agent.
4. **Re-run the eval.** Same cases, same grader. The only variable is your change.
5. **Green or iterate.** Passed the threshold? Ship, with the eval now guarding it in CI. Not yet? Read the failures — they're coordinates — and change one more thing.

The corners people cut are always the same two: they skip step 1 (build first, measure never), or they change five things in step 3 and learn nothing in step 4. Both collapse EDD back into vibes. The rule that keeps it honest is [one change, one re-eval](/blog/evals-self-improving-harnesses/) — the same reason [repeatability](/blog/the-same-way-twice/) is non-negotiable. A measurement you can't attribute to a cause isn't a measurement.

## Meta just described the same idea from the other end

Here's what makes me think EDD isn't just my tidy analogy: a much larger shop arrived at a structurally identical conclusion, coming at it from traditional testing instead of from evals.

In February 2026 Meta published [*The death of traditional testing: agentic development and the JiT testing revival*](https://engineering.fb.com/2026/02/11/developer-tools/the-death-of-traditional-testing-agentic-development-jit-testing-revival/). The premise is blunt: agentic development broke traditional testing, because code now changes faster than humans can write and maintain tests for it. Their answer is **Just-in-Time Testing** — **JiTTests**: test suites an LLM generates *on the fly, per code change,* which appear when a pull request lands and disappear after they've done their job. No persistent test files. No maintenance. Bespoke tests tailored to one specific diff.

Their "Catching JiTTest" pipeline, roughly: code lands → the system **infers the change's intention** → it creates deliberate fault variants (mutants) → it generates and runs targeted tests against them → **rule-based and LLM-based assessors** filter out false positives → and an engineer only hears about it when a *real* bug surfaces. (Meta keeps the claims qualitative in that piece — the pitch is "eliminate maintenance, keep up with agentic velocity," not a benchmark table.)

Read that back and notice how much of it is EDD in a different costume:

- **Intent is the pivot.** JiTTests start by inferring what the change was *supposed* to do. EDD starts by stating what a good output *should* be. Both put a model's judgment about *intent* at the center of verification, where a string-match used to sit — the same move as an [LLM-as-judge](/blog/custom-geval-claude-subagent/).
- **Generated, not hand-maintained.** Meta's tests are ephemeral and machine-written because human-maintained suites can't keep pace. Evals lean the same way: your grader is often itself a model, and your case set grows automatically every time production surprises you.
- **Verification tuned for agentic speed.** Both exist because *execution got cheap and fast.* When an agent can rewrite a module in a minute, the bottleneck becomes "how do we know it's still good?" — and the only answer that scales is verification that's as automated as the code generation.
- **Signal over noise, by construction.** Meta's assessors kill false positives so engineers only see real bugs; a good eval's *reason* field tells you *why* a case failed so you get a ticket, not a shrug. Both are engineered so the human only spends attention on true signal.

Where they differ is the layer, and it's worth being precise so you use both instead of conflating them. **JIT testing checks the correctness of a specific code change** — did this diff introduce a fault. **EDD measures the behavioral quality of the AI system's output** — is the summary faithful, is the reply on-policy, did the agent take the right steps. JIT is a net under the code; EDD is a gauge on the behavior. You want both: JiTTests (or their open-source cousins, as they land) guarding the diffs, evals guarding the outputs. Same philosophy — *generated, intent-aware, continuous verification* — applied to two different failure surfaces.

The reason this convergence matters: when a lab the size of Meta rebuilds its testing strategy around "infer intent, generate the check, run it continuously, only surface real signal," and a solo developer wiring up DeepEval independently arrives at the same shape, that's not a coincidence. That's the industry discovering that in agentic development, **verification has to be generated and measured, not written once and trusted forever.** EDD is just the name for doing it on purpose in your own loop.

## Where to start tomorrow

You do not need a JiTTest pipeline to practice EDD. You need to flip the order on the *next* AI feature you build:

- **Before you write the prompt, write five cases** and one rubric describing a good answer. Pick the five that would embarrass you if they broke.
- **Run it and let it fail.** The red bar is the point. That's your spec, made executable.
- **Build until it's green,** one change at a time, re-running the eval on each.
- **Leave the eval in CI** so the definition of done keeps holding after you've moved on — a [gate that blocks on regressions](/blog/evals-self-improving-harnesses/), not a smoke detector with the battery pulled.

That's it. It's TDD's oldest, best instinct — *the check comes first* — pointed at the fuzzy, generative, non-deterministic layer where most software is now being built. Meta calls their version JiT testing. You can call yours whatever you want. Just write the eval first.
