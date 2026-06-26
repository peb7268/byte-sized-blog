---
title: 'The Review Is the Work Now'
description: "Developers fear agentic AI is pulling them out of the code and that reviewing it eats their time. The real shift isn't coding-plus-overhead — it's soloist to conductor, Organic Intelligence to AI."
pubDate: 'Jun 26 2026'
heroImage: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97'
draft: false
---

A developer I work with said something that's stuck with me. He was describing what it feels like to build a feature when agents are driving the implementation, and he put the discomfort more precisely than I've heard anyone manage:

> *When I get to step 3 of a delivery plan, or step 5, I don't know what's going on anymore. If I would have developed this feature organically, I would have.*

I can't personally vouch for him — I'm not in a position to grade his work — but from what I hear he's a strong engineer, and that's almost beside the point. Because this concern isn't his alone. I've heard the same unease echoed by a lot of developers I've come across, online and in person: a quiet worry that the way they're being asked to work is loosening their grip on the thing they're good at.

That one word — *organically* — is the tell. What he's describing is the erosion of something I want to give a name to: **Organic Intelligence**. OI is the hands-on-keyboard understanding you accrue by building a thing yourself, line by line, mistake by mistake — the model of the system that lives in your head precisely because you grew it.

And I think the shift we're all living through right now is best described as exactly this: a migration away from leaning on **OI** (your own organic intelligence) toward leaning on **AI**. The pull toward AI is speed. The pull back toward OI is comprehension — and the fear of what it means to need less of it. It's the move from being the **implementer** to being the **orchestrator**. From soloist to conductor. You're not playing the violin yourself anymore; you're standing in front of a symphony of agents, trying to make them play together.

That's the real subject here. And the framing most of us bring to it — including, at first, me — is backwards. Getting it right is the difference between a team that compounds with these tools and one that quietly rots while shipping more than ever. Let me explain why "the review takes too long" is the most important sentence on a team right now.

## The complaint underneath the complaint

The surface complaints are consistent, and you've probably heard them (or said them):

- *"The spec-driven development docs are too technical and take too long to read."*
- *"By step three or five of the plan, I've lost the thread of what's actually happening."*
- *"Reviewing all this AI output takes me longer than just writing it would have."*

And the deep one: *"I'm worried my skills are atrophying"* — worried, in other words, about losing OI.

Every one of those is true. They're not whining; the data backs them up. Where we go wrong is the conclusion we draw — that this is friction to minimize, a tax on the "real work" of coding. It isn't a tax. **It's the relocation of the work itself.**

## The role moved, and most of us are still standing where it used to be

The shift is not subtle, and it's not coming — it's here. In Sonar's [2026 State of Code survey](https://shiftmag.dev/state-of-code-2025-7978/), developers ranked "reviewing and validating AI-generated code for quality and security" as the **single most important skill** of the AI era (47%) — above writing code itself. Around 42% of code is now AI-assisted, and yet 96% of developers say they don't fully trust it. Read those two numbers together: we've handed off the typing and kept all of the responsibility.

That's the job now. As one summary of the shift put it, developers "no longer write code from scratch — they direct, review, and optimize AI-generated code." The center of gravity moved from **author** to **editor, validator, and conductor**. The soloist became the orchestrator.

So when an engineer says reviewing this takes longer than writing it, he's not describing a failure. He's describing the new center of gravity — and mistaking it for overhead, because he's still mentally filing "review" under *interruptions to coding* instead of *the coding*.

## Why review genuinely feels slower (it's not in your head)

Two pieces of research make this concrete, and they're worth sitting with.

First, METR ran a [randomized controlled trial](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/) on experienced open-source developers working in codebases they knew well. The result was the most uncomfortable finding of 2025: with AI tools, they were **19% slower**. The kicker? They *predicted* AI would make them 24% faster, and even *after finishing* believed it had made them ~20% faster. They were slower and were certain they were faster.

That gap is the whole story. The time didn't vanish — it moved into reconstructing intent, validating assumptions, and checking edge cases on code you didn't write and can't introspect the reasoning behind. Reviewing AI-generated code is *demonstrably harder* than reviewing a human colleague's, because you can't ask the model "what were you thinking here?" and get an honest answer. AI pull requests carry roughly [1.7x more defects](https://shiftmag.dev/state-of-code-2025-7978/) than human-authored ones. The verification burden is real, it's measurable, and it's exactly where the hours are supposed to go.

So plainly: **the reason it takes longer to review is that this is now where your job's time is supposed to live.** You're not doing review *and* the work. The review *is* the work. The mistake is the addition sign. It should be a substitution — less hand-coding, more specifying, reviewing, and orchestrating. Conducting, not soloing.

## The fear is legitimate — and it points the opposite direction you think

Now, the atrophy worry. I don't want to wave it away, because it's the most honest concern in the whole conversation, and the research validates it hard.

A [Microsoft Research and Carnegie Mellon study](https://www.microsoft.com/en-us/research/publication/the-impact-of-generative-ai-on-critical-thinking-self-reported-reductions-in-cognitive-effort-and-confidence-effects-from-a-survey-of-knowledge-workers/) of 319 knowledge workers found that the higher your confidence in the AI, the *less* critical thinking you do — classic cognitive offloading, delegating to the machine the very judgment you should be exercising. The atrophy of Organic Intelligence is a real mechanism, not a vibe.

But here's the part everyone stops reading before they reach: the same study found that GenAI **shifts the nature of critical thinking** "toward information verification, response integration, and task stewardship." It doesn't delete the thinking. It moves it — to the conductor's stand.

So the two fears developers hold — *"my OI will atrophy"* and *"the review is eating my day"* — feel contradictory but aren't. The resolution is the uncomfortable one: **the engaged review is the thing that prevents the atrophy.** OI doesn't decay because you used AI. It decays when you *disengage from the verification*. Skimming the spec and governance docs and rubber-stamping the output isn't the antidote to cognitive offloading — it *is* the cognitive offloading. "I don't know what's happening at step three" isn't a reason to retreat to developing it organically. It's the instrument panel flashing the exact coordinate where your attention — your OI — is now most valuable. A conductor who loses the second violins doesn't put down the baton and pick the violin back up. He listens harder.

## What happens to the teams that don't make the shift

If you want to see the failure mode in high resolution, look at what's already happening to companies that went all-in on AI and treated the human review as the thing to *eliminate* rather than the thing to *invest in*.

Stanford's Social Media Lab and BetterUp Labs coined the term ["workslop"](https://hbr.org/2025/09/ai-generated-workslop-is-destroying-productivity) for it — AI-generated work that "masquerades as good work but lacks the substance to meaningfully advance a task." In their survey, 40% of workers had received it; each incident took ~2 hours to clean up; the bill comes to roughly **$9 million a year** for a 10,000-person company. Harvard Business Review's follow-up describes the org-level version as ["knowledge decay"](https://hbr.org/2026/06/dont-let-ai-slop-muck-up-your-companys-processes): errors compound, trust in internal information erodes, and institutional expertise thins as people lean on the model instead of building the muscle. As [Futurism summarized it](https://futurism.com/future-society/companies-embraced-ai-rotting-away), companies that embraced AI without that discipline are "rotting away" — an AI hangover that haunts them for years.

Notice the shape of the cure HBR prescribes: information has to be "meticulously verified and cleared of AI hallucinations," a labor-intensive process that "eats up the time of actual human employees." That's not an argument against AI. **It's the strongest argument I've seen for treating review as the main event.** The teams that rot are precisely the ones who tried to skip it.

## So what do we actually do

For engineers (including me):

- **Drop the addition sign.** Stop accounting for review as time stolen from "real work." Re-budget your week so review, spec-writing, and orchestration are *the* work, with hand-coding the smaller slice.
- **Run toward step three.** The moment you lose the thread is the moment your judgment — your OI — is most needed, not least. That discomfort is the signal, not the failure.
- **Stay engaged on purpose.** The atrophy is real, and the only known defense is active verification. Read the spec. Reconstruct the intent. Disagree with the agent out loud.

But — and this is the half the engineers are right about — **leaders and tool-builders own the other side of this.**

When developers say the spec-driven development docs are "too technical and take too long to read," that is not only a developer problem. If the oversight surface isn't *legible*, we've just relocated the slop into the governance layer. A planning agent that emits exhaustive-but-unreadable docs taxes the review instead of enabling it. The Microsoft study is clear that the new skill is verification and stewardship; our job as leaders is to make that skill *cheap to exercise* — to design oversight artifacts that let an engineer understand step three in thirty seconds, not thirty minutes.

That's the bar worth holding a planning agent to. Not "did it produce complete documentation," but "did it make the review fast." Completeness is easy. Legibility is the actual product. A good conductor's score is readable at a glance.

## The honest version

The developers grumbling about review time are sensing something true: their job changed underneath them and nobody re-drew the map. They're right that it takes time. They're right to fear the atrophy of their Organic Intelligence. Where I'd push back — gently, because I felt it too — is the instinct that the answer is *less review and more developing things organically*. The data points the other way. The review is where the judgment lives now, the OI you're afraid of losing survives by being spent there, and the companies that are rotting are the ones who tried to skip it.

The lever to push is not "do AI review faster so we can get back to coding." It's: **this *is* the coding now.** We're conductors. Let's get good at it — and let's build tools that make the score worth reading.

How's your team navigating the same shift — from soloist to orchestrator, from OI to AI? I'd genuinely like to compare notes, especially from anyone who's found a way to make agentic governance legible without dumbing it down.

---

### Sources

- [Companies That Embraced AI Are Now Rotting Away in a Very Specific Way](https://futurism.com/future-society/companies-embraced-ai-rotting-away) — Futurism (Victor Tangermann)
- [Don't Let AI Slop Muck Up Your Company's Processes](https://hbr.org/2026/06/dont-let-ai-slop-muck-up-your-companys-processes) — Harvard Business Review (Holweg & Davenport), on "knowledge decay"
- [AI-Generated "Workslop" Is Destroying Productivity](https://hbr.org/2025/09/ai-generated-workslop-is-destroying-productivity) — HBR / [BetterUp Labs + Stanford Social Media Lab](https://www.betterup.com/workslop)
- [Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/) — METR (the 19%-slower RCT)
- [The Impact of Generative AI on Critical Thinking](https://www.microsoft.com/en-us/research/publication/the-impact-of-generative-ai-on-critical-thinking-self-reported-reductions-in-cognitive-effort-and-confidence-effects-from-a-survey-of-knowledge-workers/) — Microsoft Research & Carnegie Mellon
- [State of Code 2026 / "42% of Code Is AI-Assisted, But 96% Don't Fully Trust It"](https://shiftmag.dev/state-of-code-2025-7978/) — Sonar developer survey
