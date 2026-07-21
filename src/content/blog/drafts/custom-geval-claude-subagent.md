---
title: 'A Custom G-Eval Grade with a Claude Subagent'
description: "Off-the-shelf metrics never fit your domain. Here's the concrete build: a Claude Code subagent that acts as a G-Eval judge, wired into Vitest so a rubric you wrote becomes a pass/fail in CI — with the full agent definition and the test code."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1564097147829-44f8c74a8549'
draft: true
series: 'Ship Confidence'
seriesOrder: 3
tags: ['evals', 'g-eval', 'vitest']
hashtags: ['aiengineering', 'evals', 'llmasajudge']
---

In [What Are Evals?](/internal/what-are-evals/) I argued that "it worked when I tried it" isn't engineering. And in [An Intro to DeepEval](/internal/intro-to-deepeval/) the built-in metrics did a lot of the work for you. But the first time you try to grade something that's actually *yours* — "is this summary faithful to our docs?", "does this reply follow our refund policy?", "is this commit message any good?" — the canned metrics shrug. Nobody shipped a metric for your rubric.

That's what **G-Eval** is for. And the most useful judge I've found for a custom G-Eval isn't a library call — it's a **Claude Code subagent** with its own isolated context, doing nothing but grading. This post is the concrete build: the agent, the glue, and the [Vitest](https://vitest.dev/) tests that turn your rubric into a green check.

## What G-Eval actually is

G-Eval is **LLM-as-a-judge with chain-of-thought**. Two ideas do the heavy lifting (per the [DeepEval docs](https://deepeval.com/docs/metrics-llm-evals) and [Confident AI's guide](https://www.confident-ai.com/blog/g-eval-the-definitive-guide)):

1. **Derive evaluation steps first, score last.** Instead of "rate this 1–5," you give the judge *criteria*, it expands them into 3–5 concrete checks, reasons through each against the output, and *then* scores. The reasoning grounds the number and makes it far more stable.
2. **Anchored, independent criteria.** Three to five checks, each specific and observable, each with a clear sense of what passes vs fails. Vague criteria → vague scores.

[The research is blunt about why this beats string-matching](https://arxiv.org/abs/2303.16634): G-Eval correlates with human judgment on things like coherence, faithfulness, and relevance that BLEU or exact-match can't see at all.

## Why a Claude Code subagent makes the right judge

![A competition judge seated behind a frosted glass partition, scoring only the object on the pedestal in front of them while the contestant stays hidden on the far side — an impartial judge with isolated context.](/img/custom-geval-claude-subagent/blind-judge-isolated-context.png)

You can call an LLM judge inline. But there's a failure mode the eval community keeps re-learning (the [doer/judge pattern writeup](https://pub.towardsai.net/from-claude-code-skills-to-adversarial-subagent-orchestrators-to-the-claude-agent-sdk-three-e1dedfd067b1) is good on this): **a model grading its own output, in its own context, grades generously.** It has already convinced itself.

A **subagent** fixes this structurally:

- **Isolated context.** The judge never sees the doer's reasoning — only the rubric, the input, and the output. It can't be charmed by how confidently the answer was produced. (Same "evidence over self-report" idea as [Jerry Maguire These Agents](/blog/trust-but-verify/).)
- **One job, defined once.** The rubric, the chain-of-thought discipline, and the anti-bias rules live in the agent definition — not copy-pasted into every test.
- **Structured verdict.** It returns strict JSON, so your harness gets a number, not a vibe.
- **Reusable everywhere.** `claude --agent geval-judge` works from a test, a pre-commit hook, or CI.

## Step 1 — the testing agent (the judge)

Drop this in `.claude/agents/geval-judge.md`. It's a real Claude Code subagent: it derives the eval steps, walks them, and emits a JSON verdict — nothing else.

```markdown
---
name: geval-judge
description: LLM-as-judge for G-Eval-style grading. Given a task input, an actual
  output, and a rubric, it derives evaluation steps (chain-of-thought), reasons
  through them, and returns strict JSON {score, pass, steps, reasoning}. Invoke as
  a SEPARATE subagent so a model never grades its own output.
tools: Read
---

You are a strict, impartial evaluation judge implementing the G-Eval method. You do
not write or fix the work under test — you only grade it.

## Input
A message with fenced sections: CRITERIA (the rubric + optional threshold), INPUT
(what the system was asked), OUTPUT (what to grade), and optional EXPECTED (a
reference — a guide, not a strict diff).

## How to grade, in order
1. Derive 3–5 concrete, independent, observable evaluation steps from CRITERIA;
   anchor each (what passes vs fails). Reason first, score last.
2. Walk each step against OUTPUT, quoting specific evidence.
3. Score 0.00–1.00 as the fraction of the rubric genuinely satisfied. Use the full
   range; don't cluster at 0.5.
4. pass = score ≥ threshold (default 0.7).

## Anti-bias rules
- Judge ONLY against CRITERIA. Ignore length, style, fluency, confident tone.
- If unsure, score DOWN and say why. Penalize unsupported claims.
- Be deterministic: same inputs → same verdict.

## Output contract — CRITICAL
Reply with ONLY one JSON object, no prose, no fences:
{"score": 0.0, "pass": false, "steps": ["..."], "reasoning": "evidence-grounded paragraph"}
```

That `tools: Read` line matters: the judge needs almost no power. It reads and reasons; it doesn't edit, run, or commit. Least privilege for the grader.

## Step 2 — the glue: call the subagent, get a verdict

A tiny wrapper shells out to the subagent and parses the JSON. Headless Claude Code (`claude -p`) returns the agent's final message on stdout — which, by our contract, *is* the verdict.

```ts
// geval-judge.ts
import { execa } from "execa";

export type Verdict = { score: number; pass: boolean; steps: string[]; reasoning: string };

export async function gevalJudge(opts: {
  input: string;
  output: string;
  criteria: string;
  expected?: string;
  threshold?: number;
}): Promise<Verdict> {
  const { input, output, criteria, expected, threshold = 0.7 } = opts;

  const prompt = [
    `CRITERIA:\n${criteria}\nthreshold: ${threshold}`,
    `INPUT:\n${input}`,
    `OUTPUT:\n${output}`,
    expected ? `EXPECTED:\n${expected}` : "",
  ].filter(Boolean).join("\n\n");

  const { stdout } = await execa("claude", ["--agent", "geval-judge", "-p", prompt]);

  // The agent emits only JSON; be defensive and grab the object even if anything wraps it.
  const json = stdout.match(/\{[\s\S]*\}/);
  if (!json) throw new Error(`judge returned no JSON:\n${stdout}`);
  return JSON.parse(json[0]) as Verdict;
}
```

(Prefer the programmatic route in CI? Swap `execa` for the [Claude Agent SDK](https://platform.claude.com/docs)'s `query()` with `agent: "geval-judge"` — same contract, no subprocess.)

## Step 3 — write the rubric (this is the actual work)

![A referee's printed scoring rubric on a clipboard — each line a checkbox anchored with a pass/fail mark, a red pen resting across it, one box unchecked and circled.](/img/custom-geval-claude-subagent/anchored-rubric-scorecard.png)

The criteria *are* the metric. Spend your effort here, not on the plumbing.

```ts
// rubrics.ts
export const FAITHFUL_SUMMARY = `
Grade whether the OUTPUT summary is faithful to the INPUT source.
- Every claim in the summary is supported by the source (no hallucinations).
- It captures the source's single most important point.
- It never contradicts the source.
- It omits nothing the source treats as critical.
`;
```

Three to five checks, observable, independent. Notice none of them mention length or tone — those are exactly the traps the judge is told to ignore.

## Step 4 — make it a Vitest assertion

The whole point is that this runs in your normal test suite. Plainest version — a custom matcher:

```ts
// setup.ts
import { expect } from "vitest";
import { gevalJudge } from "./geval-judge";

expect.extend({
  async toPassGEval(output: string, args: { input: string; criteria: string; threshold?: number }) {
    const v = await gevalJudge({ output, ...args });
    return {
      pass: v.pass,
      message: () => `G-Eval scored ${v.score} (threshold ${args.threshold ?? 0.7})\n${v.reasoning}`,
    };
  },
});
```

```ts
// summarize.eval.ts
import { describe, it, expect } from "vitest";
import { summarize } from "../src/summarize";
import { FAITHFUL_SUMMARY } from "./rubrics";

describe("summarizer", () => {
  it("produces a faithful summary", async () => {
    const input = "…source document…";
    const output = await summarize(input);
    await expect(output).toPassGEval({ input, criteria: FAITHFUL_SUMMARY, threshold: 0.8 });
  });
});
```

Run `vitest`. A faithful summary is green; a hallucinated one fails with the judge's *reasoning* printed — so a red test tells you **why**, not just "≠ expected".

### Or lean on vitest-evals

If you want datasets and thresholds handled for you, [`vitest-evals`](https://github.com/getsentry/vitest-evals) gives you `describeEval` and lets you plug in a **custom scorer** — which is exactly where our subagent goes. A scorer just returns `{ score, rationale }`:

```ts
import { describeEval } from "vitest-evals";
import { gevalJudge } from "./geval-judge";
import { FAITHFUL_SUMMARY } from "./rubrics";
import { summarize } from "../src/summarize";

// our Claude subagent, dressed as a vitest-evals scorer
const GEval = (criteria: string, threshold = 0.7) => async (ctx: { input: string; output: string }) => {
  const v = await gevalJudge({ input: ctx.input, output: ctx.output, criteria, threshold });
  return { score: v.score, rationale: v.reasoning };
};

describeEval("summaries are faithful", {
  data: async () => [{ input: "…source…", expected: "…optional reference…" }],
  task: async (input: string) => summarize(input),
  scorers: [GEval(FAITHFUL_SUMMARY, 0.8)],
  threshold: 0.8,
});
```

Same judge, same rubric — now with batch data and a suite-level threshold gate.

## The traps (learned the hard way)

- **Don't let the doer judge.** The whole reason this is a separate subagent. If your agent both writes and grades in one context, the grade is theater.
- **Vague criteria = noisy scores.** "Is it good?" is not a rubric. Anchor every check.
- **Position and verbosity bias are real.** Longer, more confident answers get over-rated unless you explicitly tell the judge to ignore that — which the agent above does.
- **Pin the judge model.** A grader you can't reproduce isn't a measurement. Same model + same rubric → same verdict (ties to [The Same Way Twice](/blog/the-same-way-twice/)).
- **Sanity-check the judge against yourself.** Grade ~10 examples by hand and compare. If the judge disagrees with you, fix the *rubric* before you trust the number.

A custom G-Eval is just this: a rubric you believe in, a judge that can't cheat, and a green check that means something. Once it's wired, every change to your prompt or your model gets graded automatically — which is the whole on-ramp to the [self-improving harness](/internal/evals-self-improving-harnesses/) the next post is about.

---

*Sources: [DeepEval — G-Eval](https://deepeval.com/docs/metrics-llm-evals) · [Confident AI — G-Eval guide](https://www.confident-ai.com/blog/g-eval-the-definitive-guide) · [getsentry/vitest-evals](https://github.com/getsentry/vitest-evals) · [Running evals in Vitest](https://cra.mr/vitest-evals/) · [doer/judge subagents](https://pub.towardsai.net/from-claude-code-skills-to-adversarial-subagent-orchestrators-to-the-claude-agent-sdk-three-e1dedfd067b1).*
