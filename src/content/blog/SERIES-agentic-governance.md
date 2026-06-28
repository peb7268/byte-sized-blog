# Series roadmap — Agentic Governance

Editorial plan for the **Agentic Governance** blog series (blog.byte-sized.io). Posts carry
`series: 'Agentic Governance'` + `seriesOrder: N` frontmatter; the site's SeriesNav links First/Prev/Next.
(Sibling series planned: **Agentic Foundations** — definitional pieces: "what is governance", "what is
token economics", etc.)

## The 5 governance pillars (series thematic spine)
1. **Human Oversight & Autonomy Boundaries** — balancing an agent's independent decisions with guardrails
   and human-in-the-loop checkpoints.
2. **Accountability & Liability** — who is legally/ethically responsible when an autonomous agent acts or
   errs without direct human intervention.
3. **Security & Risk Control** — agentic threats: prompt injection, privilege escalation, unauthorized or
   malicious tool invocation.
4. **Runtime Governance & Behavioral Drift** — real-time monitoring to detect when an agent's behavior
   shifts/degrades from its original intent.
5. **Multi-Agent Coordination & Emergence** — interactions, conflicts, and unpredictable emergent behavior
   when multiple autonomous agents collaborate.

## Issues
### 01 — The Review Is the Work Now ✅ (published)
- File: `the-review-is-the-work-now.md` · live: blog.byte-sized.io/blog/the-review-is-the-work-now/
- Pillar: **#1 Human Oversight & Autonomy Boundaries** — the engaged human review/verification as the
  guardrail that prevents skill atrophy; soloist→conductor.

### (planned) — Spec-Driven Development: doing the task the same way twice
- **Topic added by Paul 2026-06-27.** Thesis: spec-driven development gives agents **deterministic,
  reproducible behavior** — the same task executed the same way twice — by anchoring execution to an
  explicit spec.
- **Pillar: #4 Runtime Governance & Behavioral Drift.**
  - *Why here:* "behavioral drift" = an agent deviating from its **original intent**. A spec is that
    intent, written down. Spec-driven development is the **design-time / preventive** counterpart to
    runtime drift-monitoring: it makes behavior deterministic (low drift by construction) **and** gives
    you a stable, machine-checkable baseline to compare live runs against. Determinism is the antidote
    to drift.
  - *Secondary tie-in:* the spec also functions as a **guardrail** (pillar #1) — but the "same way
    twice / deterministic" framing is squarely a drift/consistency argument, so it lives under #4.
  - *Angles to develop:* spec as executable contract; reproducibility as a governance primitive;
    diffing runtime behavior vs. spec to catch drift; how non-determinism (temperature, tool order,
    context) erodes reproducibility and what to pin.

## Backlog (one issue per pillar as the series fills out)
- #2 Accountability & Liability — responsibility when an agent acts unsupervised.
- #3 Security & Risk Control — prompt injection / privilege escalation / tool-invocation guardrails.
- #4 Runtime Governance & Behavioral Drift — **(spec-driven determinism slots here; see above)** +
  the monitoring/detection side.
- #5 Multi-Agent Coordination & Emergence — emergent behavior in agent swarms.
