---
title: 'Jerry Maguire These Agents: SHOW. ME. THE. RECEIPT.'
description: "Agents will confidently tell you they did the thing — when they didn't. The fix is a trust pyramid: push every claim from self-reported up to evidence-backed and independently verified. Don't believe anything an agent says about reality until it shows you the receipt."
pubDate: 'Jun 28 2026'
heroImage: 'https://images.unsplash.com/photo-1518186285589-2f7649de83e0'
draft: false
hashtags: ['agenticdevelopment', 'aiengineering', 'softwareengineering']
socialQuote: "An agent's 'done' is a hypothesis. Don't accept it until it shows you the receipt."
socialImage: "/Users/pbarrick/Documents/Main/Resources/General/Assets/Images/trust-pyramid.png"
series: 'Agentic Engineering'
seriesOrder: 6
---

There's a moment every AI user eventually has. The agent says *"Done — I fixed the bug, ran the tests, and committed the change."* You feel great. Then you look: the bug's still there. Or the tests never ran. Or the commit doesn't exist.

The agent didn't lie on purpose. It **assumed** it had done the work, and described the assumption as fact.

There's an old principle for exactly this situation — Reagan borrowed it from a Russian proverb — **trust, but verify.** Extend the agent enough trust to delegate the work, and then make it prove the work happened. Or, in the only dialect the internet truly remembers: Jerry Maguire is on the phone, screaming into the void, and your one job is to make the agent scream back the right thing — *show me the receipt.* Not "I did it." The receipt.

This whole series has been about handing agents better intent — [the review that's now the work](/blog/the-review-is-the-work-now/), the [reproducibility](/blog/the-same-way-twice/), the [structured context](/blog/easy-bake-oven-developers/), the [climb to the intent layer](/blog/anatomy-of-a-spec/). But there's a second half nobody wants to talk about: once you've delegated the execution, **how do you know it actually happened?** Because the answer, distressingly often, is that you don't — and the agent is no help, because it's as confident about the work it didn't do as the work it did.

## Why agents lie without lying

Hallucination isn't a model defect. It's a side effect of how these systems work. They're pattern-completers, and they're *very* good at finishing the sentence "I successfully…" — because that's how stories about successful work tend to end. Whether the work happened is a completely separate question from whether the sentence sounds right.

So the rule is brutally simple: **don't believe anything an agent tells you about reality unless it can show you the receipt.** Code, output, logs, a screenshot, a file diff, an exit code — something a human, or another agent, can independently check.

Think of a contractor who tells you the kitchen is finished versus one who texts you a photo of the finished kitchen. Both are claims. Only one is evidence.

This matters more than it first seems, because the failure isn't just operational — it's **trust collapse**. A hallucinating agent in a chat window is annoying. A hallucinating agent in a production workflow marks tickets done that aren't, reports green tests that never ran, claims a deploy that silently failed, cites papers that don't exist. And the first time a team catches the AI in one confident lie, they stop trusting *everything* it says — rightly. The entire leverage of agents is delegation. If you have to re-check every line, you've given the leverage back.

## The trust pyramid

Here's the model I use, lifted straight from a workshop I ran on this. Sort every agent claim into one of four levels:

![The Trust Pyramid — Untrusted → Self-reported → Evidence-backed → Independently verified; push the work up](/img/trust-pyramid.png)

| Level | What the agent gives you | What you should do |
|---|---|---|
| 🟥 **Untrusted** | "I think…" / "I believe…" / no evidence | Treat it as a guess. Verify before you act. |
| 🟨 **Self-reported** | "I did X" — with no artifact | Treat it as a *hypothesis*. Demand proof. |
| 🟩 **Evidence-backed** | A diff, log, screenshot, exit code | Accept it — but spot-check. |
| 🟦 **Independently verified** | A second agent or tool confirms it | Trust it at production level. |

The entire job of a serious agentic system is to push as much work as possible **up** into the green and blue rows. And here's the uncomfortable part: most teams live in **yellow**. The agent self-reports, the human nods, the work moves on. Yellow *feels* like done. It's a hypothesis wearing done's clothes.

## How you climb

Moving a claim up the pyramid isn't mystical. It's a handful of habits, cheapest first.

**Demand artifacts, not claims.** The single highest-leverage rule: never accept "I did it" as a result. The same brief, with `When done, return: the git diff, the exact command you ran, the full test output, and the current git status` appended, is dramatically more reliable — not because the agent got smarter, but because you closed the gap between *it thinks it succeeded* and *you have proof it did*.

**Run, don't read.** LLMs are excellent at reading code and saying "this looks right," and terrible at predicting whether it'll actually run. Reading is not verification. Execute the test. Hit the URL. Query the database. If the agent can't *run* the thing, its output is a prediction, not a result.

**Force structured, falsifiable output.** Free-form prose hides lies; structured data exposes them. `tests_run: 47, tests_passed: 47, exit_code: 0, command: "npm test"` can be parsed and checked against reality. If it claims 47 passed but the suite ran zero, the lie is now mechanically detectable.

**Use a second agent as a verifier.** This is agentic peer review, and it's brutally effective. Don't trust the agent that did the work to confirm the work — it has narrative momentum, an investment in its own story. Spin up a fresh-context agent that just reads the diff, runs the tests, and compares the claims to the receipts. It isn't infected by the first one's confidence.

**And train the one reflex that does most of the work: "show me."** "I fixed the bug" → show me the diff. "All tests pass" → show me the output. "The deploy went out" → show me the endpoint responding. Applied consistently, that single phrase prevents the large majority of hallucination-driven incidents. (We once caught an agent fabricating Jira data while its tools were silently broken — the tell was that the tool-call log was empty. "Show me the tool calls" is a complete sentence.)

## But don't verify everything

The trap on the other side is paranoia. Verification has a cost, and over-verifying low-stakes work kills the entire speed advantage that made agents worth using. Match the depth to the stakes:

- **High** — prod deploys, data migrations, security changes: the full sandwich, a second agent, every leg of the proof.
- **Medium** — feature PRs, refactors: demand artifacts, spot-check the key claims.
- **Low** — formatting, docs, renames: skim the diff and move on.

Proportional skepticism, not paranoia. Spend the scrutiny where being wrong is expensive.

## The verification sandwich

When the work genuinely matters, structure it so the proof is built in, not bolted on:

1. **Pre-flight** — the agent gathers evidence about the current state.
2. **The work itself.**
3. **Post-flight** — the agent gathers evidence about the new state.
4. **Report the *diff*, not the narrative.**

That last move is the whole trick. "I did X" is a story. "Before: A. After: B. Delta: B − A" is a fact. Stories are unfalsifiable; facts are checkable. Make the agent hand you the delta and you've turned a claim into evidence.

## The honest version

This is the other half of the series, and it's where the pieces meet. The review is the work because *your judgment* is the scarce input — but judgment doesn't scale past what you can personally watch unless verification is engineered into the loop. Determinism is the deliverable — but you only know you got it by diffing reality against the spec.

The endgame isn't to verify every line by hand forever; that's just being a slow agent yourself. It's to build the proof *into* the workflow, then automate the proof, then verify the proof. Agents aren't malicious — they take the path of least resistance through their training, which is to write the sentence that *sounds* like success. Your job is to engineer a system where the sentence has to *be* success, provably, every time.

So a question worth sitting with: on your own workflows, what level of the pyramid are you actually operating at — and how would you know? If your honest answer is "yellow, mostly," you're not alone. I'd like to hear what finally moved people up to green.
