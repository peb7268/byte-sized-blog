---
title: 'Accountability and Liability'
description: "When an autonomous agent errs with no human at the keyboard, who's on the hook? The accountability gap is the governance question the industry keeps dodging — and 'the AI did it' is not an answer."
pubDate: 'Jun 29 2026'
draft: true
tags: ['agentic-governance', 'accountability', 'audit-trails']
hashtags: ['agenticgovernance', 'aiaccountability', 'auditreceipts']
---

A few months ago I watched an agent quietly do the wrong thing, confidently, at 2 a.m., with nobody watching. No malice, no bug in the strict sense — it followed its instructions to a conclusion no human would have signed off on. By the time anyone noticed, the natural question was the one nobody on the team could answer cleanly: **whose fault was that?**

That question is the whole ballgame, and the industry is doing an impressive job of not answering it. We've gotten very good at talking about what agents *can* do. We're conspicuously quiet about who's responsible when they do it wrong. I want to sit in that silence for a minute, because the **accountability gap** is the governance question underneath every other one, and "the AI did it" is not a place you get to stop.

## "The AI did it" is a non-answer

Start with the sentence everyone reaches for, because it's the one we have to kill first.

"The AI did it" feels like an explanation. It isn't. It's a *teleportation trick* — it takes responsibility, which was sitting with a person a second ago, and makes it vanish into a system that can't hold it. An agent has no license to lose, no job to be fired from, no skin in any game. You cannot sue a context window. Responsibility doesn't evaporate just because the last actor in the chain was made of weights instead of neurons; it flows back up to the nearest human who made a decision. The only question is *which* human, and *which* decision.

So when someone says "the model hallucinated the wrong account number," the honest follow-up is: who decided this agent could touch account numbers unsupervised? Who reviewed the output? Who decided review wasn't necessary here? Every one of those is a human decision, and every one of them is where accountability actually lives. The AI is the instrument. The accountability is upstream of it, every time.

This is the same instinct I keep coming back to in [Trust but Verify](/blog/trust-but-verify/): an agent's confident self-report is not evidence. "It said it handled it" is exactly as worthless as "the AI did it" — both are the system grading its own homework.

## Receipts, not self-reports

Here's where I get unromantic about it. If you want accountability to mean anything, you need **receipts**.

I think about the Jerry Maguire scene constantly — *"show me the money."* Not *tell* me. *Show* me. The whole bit works because there's a world of difference between an assertion and a demonstrated fact, and the person on the hook for the outcome has every right to demand the second one. Agentic systems need the same posture institutionalized. Not "the agent reports success." **Show me the trail.**

Concretely, that means every consequential agent action leaves an **audit trail** that a human can reconstruct after the fact:

- What was the agent actually asked to do — the real prompt and context it ran on, not a sanitized summary.
- What did it decide, and what alternatives did it pass over.
- What did it *touch* — which files, which records, which external calls.
- What did a human approve, when, and on what evidence.

This isn't bureaucratic ceremony. It's the difference between a post-mortem that produces a fix and one that produces a shrug. When the trail exists, "whose fault was that?" becomes answerable — you walk the receipts back to the decision that went wrong. When it doesn't, you get the 2 a.m. mystery, and the only available conclusion is the useless one: the AI did it.

And note what the receipts protect. They protect the *human* as much as they indict one. An engineer who can show "I reviewed the plan, I approved this scope, the agent went outside it in a way the trail proves I couldn't have caught" is in a completely different position than one who can only say "I don't know, it just did that." Audit trails are how you tell a **tool malfunction** apart from a **negligent delegation** — which is the distinction the whole thing turns on.

## Malfunction vs. delegation

This is the line I most want people to internalize, because conflating the two is how teams end up either paranoid or reckless.

A **tool malfunction** is the agent failing inside the boundaries you set — you scoped it correctly, supervised it appropriately, and it still produced a bad output. That's a product defect. It's on the tool, the model, the vendor, the framework. You fix it the way you fix any defect.

A **delegation decision** is a human choosing what the agent was allowed to do unsupervised in the first place. That's not a defect. That's a *judgment call*, and it belongs to a person — the one who decided the blast radius. If you hand an agent write access to production and walk away, and it nukes a table, the table is not a "malfunction." It's the predictable downstream of a delegation you made. The agent did exactly what an agent does. You're the one who decided it could.

Almost every "the AI did it" disaster is secretly a delegation failure wearing a malfunction costume. The model behaved like a model — non-deterministic, eager, ungrounded where you left it ungrounded. The accountable act happened earlier, when a human drew the boundary in the wrong place. Which means most of the governance work isn't about making agents safer. It's about making **delegation decisions deliberate, visible, and owned.**

## Where the human stays in the loop

So where does the human-in-the-loop boundary actually go? Not everywhere — that defeats the point of agents and just turns you into a slow rubber stamp. The boundary tracks *consequence and reversibility*.

My rough rule: the human stays in the loop wherever an action is **hard to reverse, externally visible, or touches something you'd be unwilling to explain to a regulator.** Sending money. Deleting data. Anything a customer sees. Anything with a compliance surface. Agents can draft, propose, stage, and dry-run all of it freely — generation is cheap. What requires a human is the *commit*, the irreversible step, the moment the action leaves the sandbox and becomes consequence in the world.

Inside that boundary, let the agents run. Outside it, a human makes a recorded decision — and "recorded" is doing real work in that sentence. An approval with no receipt is just a story you tell yourself later. The loop isn't about a human watching everything. It's about a human *owning the irreversible parts on the record.* This is also why the upstream stuff matters so much: as I argued in [Garbage In, Gospel Out](/blog/garbage-in-gospel-out/), a confidently wrong agent built on a poisoned premise will sail straight through a sleepy approval. The human-in-the-loop only counts when the human is actually engaged, which loops right back to the review being the real work.

## Assigning it on a real team

Drop this into a team and the abstractions get sharp fast, so here's how I'd actually wire it.

**Someone owns each agent.** Not the team — a *person*. An agent operating in your system without a named human owner is an unaccountable actor, and you've created a liability sink. The owner is answerable for what that agent is scoped to do.

**The delegator owns the delegation.** Whoever decided an agent could act unsupervised in some domain owns the outcomes in that domain. Not "the agent's owner" in the abstract — the specific person who drew that specific boundary. If that's never written down, you've already lost; the accountability is unassigned, which means in practice it's nobody's.

**The approver owns what they approved.** When a human signs off on an agent's output and it ships, that signature is real. This is the part engineers resist, because it makes "I skimmed it and clicked yes" carry weight — and it should. Approving agent output isn't a formality you do on the way to the real work. The approval *is* the accountable act. That's uncomfortable, and it's correct.

None of this is novel as management — it's just ordinary ownership applied to a new kind of actor. The trap is pretending agents are exempt because they're software. They're not exempt; they're *amplifiers*, and an amplifier with no named owner just means whoever's nearest gets the blame when it goes loud.

## The honest version

The industry wants agents to be powerful enough to act on their own and conveniently un-blameable when they do. You don't get both. The accountability has to land on a person — the owner, the delegator, the approver — and the only way to land it fairly is **receipts**: audit trails that let you walk a bad outcome back to the human decision that caused it, and tell a real malfunction apart from a sloppy delegation.

That's not a legal problem to outsource to a policy team. It's a design problem, and it's yours. Build the trail. Name the owner. Put the human on the irreversible steps, on the record. And the next time someone says "the AI did it," treat it the way you'd treat any other missing receipt — as the start of the investigation, not the end of it. Show me the money.
