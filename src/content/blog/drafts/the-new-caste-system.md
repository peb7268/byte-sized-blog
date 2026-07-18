---
title: 'The New Caste System: Who''s Drowning in Agentic Dev — and Where the Life Rafts Are'
description: 'A new caste system is forming around agentic AI. It has nothing to do with talent and everything to do with fluency. Here is the ladder — and how to climb it before the cheap-token party ends.'
pubDate: 'Jul 18 2026'
heroImage: 'https://images.unsplash.com/photo-1625303058423-3f8104c91e21'
draft: true
hashtags: ['agenticai', 'engineeringleadership', 'aifluency']
socialQuote: "I would rather conduct the train than be run over by it."
series: 'The New Ways of Working'
seriesOrder: 1
---

There is a caste system forming in our industry right now. Not the old one — not seniority, not pedigree, not which framework is on your résumé. A new one. And the thing that decides where you land in it has less to do with how smart you are or how long you've been doing this. It has to do with one question: **do you know how to command a team of agents, or don't you?**

Most people can't answer that yet. Most companies can't either. Everyone is in the pool at the same time, and a lot of them are drowning. This is a map of who's drowning, why, and where the life rafts actually are.

## The state of the industry: everyone is figuring this out at once

Look at the headlines. Block, Meta, Salesforce — the biggest, best-resourced engineering organizations on the planet — are all publicly reorganizing around AI, and all of them are improvising.

Look at the receipts. Block put its internal agent, [goose](https://block.xyz/inside/block-open-source-introduces-codename-goose), in front of roughly **60% of its ~12,000 employees** and says production code shipped per engineer has climbed **40%+** since it rolled out. Salesforce went further: Benioff [froze engineering hiring outright](https://sfstandard.com/2025/02/27/salesforce-marcbenioff-layoffs-tech-agents/) — "we're not adding any more software engineers" — on the claim that Agentforce and AI lifted engineering productivity **30%+**, while [reportedly committing ~$300M to Anthropic tokens](https://www.storyboard18.com/brand-marketing/salesforce-to-pour-300-million-on-anthropic-tokens-amid-engineering-hiring-freeze-98440.htm) instead. And Meta [cut ~8,000 people in May 2026](https://www.dqindia.com/news/meta-layoffs-2026-ai-restructuring-zuckerberg-mistakes-12038953), reshuffled thousands into AI units — and by June 12, Zuckerberg was circulating an internal memo **admitting the company had made mistakes restructuring around AI, and warning more were coming.**

Sit with that last one. The most resourced engineering org on earth, led by a founder-CEO with total control, publicly conceding it's getting this wrong in real time. **That's the tell: there is no playbook yet.** Everyone is standing at the edge of the same pool.

Two things are true at the same time. Some organizations are genuinely further along the journey — they've built internal harnesses, they've changed how they work, they're pulling ahead. And underneath all of it, running through everyone, is **fear.** Fear of being replaced. Fear of betting the company on technology that is not yet well understood. Fear of being the one who moved too slow — or too fast.

Fear makes people do reckless things, and the risky things are already everywhere:

- **Replacing staff with unproven technology.** Cutting the people who actually understand the domain and betting the gap gets covered by a tool nobody on the team knows how to drive yet. Aka Meta, Salesforce, ect..
- **Building entire roadmaps on top of a technology the company doesn't understand.** Committing quarters of work to a foundation leadership can't yet evaluate — because a demo looked like magic.
- **Optimizing for the wrong thing.** Everyone is racing to *build as much as fast as possible*, and almost nobody is asking the question that actually decides who survives.

## The question nobody's asking: what happens when the cheap-token party ends?

Right now, tokens are cheap and the plans are generous because there is a firehose of venture capital pointed at this industry. That firehose will not run forever. The max plans will get repriced. The subsidized inference will get more expensive. The bubble — whatever shape it takes — will find its level.

And make no mistake, it's gas money. In 2025 OpenAI reportedly [pulled in ~$3.7B in revenue and lost around $5B](https://arize.com/blog/ai-model-subsidies-ending-llm-inference-costs/) doing it. Providers are eating thin-to-negative margins to buy market share. That's the subsidy you're building on.

Here's the trap most teams walk straight into. Per-token prices *have* cracked — [GPT-4-class inference fell from about $20 per million tokens in late 2022 to well under a dollar](https://epoch.ai/data-insights/llm-inference-price-trends), roughly a **99% drop in three years**. So everyone assumes the bill goes down. It doesn't. Over the same stretch, [enterprise AI spend rose ~320%](https://www.ikangai.com/the-llm-cost-paradox-how-cheaper-ai-models-are-breaking-budgets/) — because agentic workflows fire 10–20 model calls per task, RAG inflates every context window, and always-on agents burn compute 24/7. **Cheaper tokens, bigger bills.** The per-unit price falling is exactly what lulls a team into architecting like inference is free.

While everyone is drag-racing on someone else's gas money, very few teams are asking: **what does our operation look like when the gas isn't free anymore?** Token efficiency isn't a nerdy optimization detail. It's a survival trait. The companies that treated inference like it was free will get a bill they built their whole workflow around, and they won't be able to pay it without gutting the thing they just built.

Here's the uncomfortable part: **the speed everyone wants isn't downstream of spending more.** It's downstream of *competence.* Real velocity shows up when the org learns to use the technology properly — when the systems and processes evolve to support that learning. You can't buy your way there with a bigger plan. You have to build your way there.

So the teams that come out on top aren't the ones shipping the most demos this quarter. They're the ones **positioning themselves to still be standing when the cheap tokens dry up.** How do you do that?

## Life raft #1: decouple from any single provider

Ask yourself one honest question: **can we switch between Claude, Kimi, Qwen, and Gemini without a massive sacrifice in our output?**

If the answer is no, you don't have an AI strategy — you have a dependency. Provider lock-in is the one failure mode in this entire space that is *strictly self-inflicted.* The models are commoditizing. Prices and terms will move. The team that built a harness abstract enough to swap the engine underneath keeps shipping when a provider gets expensive or degrades or changes its terms. The team that hard-wired itself to one vendor's quirks gets to choose between paying whatever they're told and rebuilding under duress.

Decoupling is not a someday-nice-to-have. It's the insurance policy you can only buy *before* you need it.

## Life raft #2: build the systems first — and educate the org at the same time

You have to do two things in parallel: build the systems that let you go fast, and teach your people to actually use them. One without the other fails.

The systems are the guardrails that make speed *safe*:

- **Spend controls** — so the cheap-token party doesn't end with a surprise invoice.
- **Observability into misuse** — so you can see who's misusing the tech, where MNPI or sensitive context might be leaking, and where the wheels are about to come off.
- **Accelerated review** — agentic security scanning and Claude-in-CI/CD to compress MR/PR cycle time, so the bottleneck doesn't just move from writing code to reviewing it.
- **Systems to *use* the freed-up time** — because here's the thing everyone misses:

> **Agentic development does not make magic time. It moves the time to a higher-leverage spot.**

It doesn't hand you free hours. It relocates where your hours are spent — from typing to directing, from producing to reviewing and orchestrating. Teams and individuals who don't know how to take advantage of that new leverage will not perform. And as orgs and leadership get better at spotting the difference, **the people who never learned to use the leverage become the ones at risk.** Not because they're bad. Because they're standing in the old spot after the value moved.

## You can't throw people in the pool and expect them to beat Olympians

Here is the mistake I see org after org make: they hand the team a tool, set an aggressive expectation, and wonder why velocity didn't triple.

That's like throwing someone in the deep end and expecting them to out-swim Olympic athletes — without ever teaching them to swim. Of course they thrash. Of course they sink. You didn't teach them to *float* first.

If you want speed, you have to teach it. Teach people how to float. Teach them how to learn the tools themselves — how to get better on their own, iteratively. Give them a roadmap to proficiency. Then **monitor AI fluency the way you'd monitor any other professional skill: name it, measure it, coach it, and set expectations against where someone actually is on the curve — not where you wish they were.** Fluency is a soft skill now. Treat it like one.

Only after you've taught people to swim do you get to set the pace.

## The part nobody wants to say out loud: the roles are blurring, and it hurts

The identities we built careers on are being washed away. The clean lines between "product decides what," "engineering decides how," and "developers write the code" are dissolving. Whole teams have to transform and re-create themselves — not once, but continuously.

That process is **profoundly uncomfortable**, and pretending otherwise is how you lose people. This is real. "AI psychosis" — the disorientation, the anxiety, the loss of professional identity — is a real cost, not a meme. If we're going to ask people to re-invent who they are at work, we owe them support while they do it.

<!-- ⚠️ ELABORATE: this is the most human section and currently the thinnest. Needs Paul's real POV on HOW to support people through the transformation — e.g. psychological safety to be a beginner again, explicit "you will be bad at this for a while and that's expected" messaging, fluency ladders that reward learning not just output, protecting people from being measured on old metrics mid-transition. 3-5 concrete supports, in your voice. This is the emotional core of the piece; don't leave it abstract. -->

### Who specs a feature now?

If we actually want to move fast, the evidence points to a **hybrid.** Product paints the rough brush strokes — the table stakes, the critical rules, the non-negotiables. Engineering fleshes out the spec from there. It's far more collaborative than the old throw-it-over-the-wall handoff.

This isn't me guessing. It's the whole thesis behind [spec-driven development](https://developer.microsoft.com/blog/spec-driven-development-ai-native-engineering/), the pattern frontier teams are converging on: write the spec first, let agents build against it, and the human's job becomes **product ownership, quality gatekeeping, and specification precision** — not typing. AWS, describing [how frontier teams are reinventing AI-native development](https://aws.amazon.com/blogs/machine-learning/how-frontier-teams-are-reinventing-ai-native-development/), reports **4.5x productivity gains, and in some cases more than 10x** — not from coding faster, but from redesigning the product-engineering boundary itself. The spec is the new interface, and it's written by product and engineering *together.*

### Who builds a proof of concept now?

Also blurry — and that's the point. For frontier teams, a PoC is a blend of product and engineering, not devs-only. A product owner with a well-built harness can ask Claude to make a plan, review that plan, and say *go* — then bounce the result off engineering. The old rhythm was: plans take weeks, PoCs take more weeks. The new rhythm is: **a day or two.** Why would we keep constraining ourselves to the old clock?

If we want to go faster, we have to loosen the reins on *who is allowed to do what*. Let people color outside the lines — and put guardrails in place so they can do it safely: agentic security scanning, Claude in CI/CD to assist the MR cycle, observability to make sure sensitive material isn't leaking. **Freedom and guardrails aren't opposites. Guardrails are what make the freedom affordable.**

## Developers: is AI coming for my job?

Straight answer: it's coming for one *version* of your job.

In the old world, a raise meant learning a new framework. Job security meant chasing the next big language. That world is gone. Superintelligence already knows every framework and every language, and **everyone has it.** Learning one more instrument is no longer enough of an edge, because the instrument is now a commodity everyone carries.

Now you don't just need to *play* the instrument. You need to be the **conductor.**

![A lone violinist under a single spotlight in a dark, empty concert hall on the left; on the right, the same stage filled with a full orchestra led by a conductor with arms raised — soloist versus orchestrator.](/img/caste-system/conductor-vs-soloist.png)

If you're a violin in a seat — heads-down, playing your one part beautifully — you are not a force multiplier anymore. If you're a good conductor, you're sitting in the current sweet spot.

And understand *why* the conductor matters, because it's the whole game: **these models are prediction engines. They cannot think well.** They don't actually know the best way to solve a specific domain problem. What they're extraordinary at is brainstorming, generating alternative approaches from good structured input, and accelerating research. The difference between that being a go-kart and an F1 car is **the driver.** At this point everyone has a similar engine. The driver is the differentiator.

Which means the job for companies is clear: **learn to make F1 race car drivers.**

## How do you develop yourself into an F1 Agent Driver?

![A go-kart and a Formula 1 car side by side on a dusk race track, both showing an identical glowing engine — same engine, different machine; the driver is the difference.](/img/caste-system/same-engine-different-driver.png)

You get good at teaching the agent to work the way a great engineer works:

- **Teach it to think through a problem the way you would** — reason about the domain, weigh tradeoffs, don't just pattern-match to the first plausible answer.
- **Teach it to plan work sequentially** — decompose a goal into ordered steps before touching code.
- **Teach it to fan out and parallelize** — recognize independent work and run it concurrently instead of single-threading everything.
- **Teach it to track its own progress** — and when it goes off the rails, to notice, loop back, try another approach, debug, and resume. Self-correction is the skill that separates a toy from a teammate.

That's the craft now. Not typing faster. *Directing* better.

## The new caste system

Here's the ladder. Find yourself on it honestly, because pretending you're a rung higher than you are is its own kind of risk.

![A ladder rising out of dark ocean water toward bright light, with human figures at different rungs — one struggling at the waterline, one climbing, one near the top reaching the light.](/img/caste-system/caste-ladder.png)

### Caste 1 — People who have no idea what's already here

- **1.1 — Developers** still treating this as a fad: "I'll keep learning frameworks and languages, I'm just better than AI and those 'vibe coders.'"
- **1.2 — Product owners** who pride themselves on "these things don't know my domain and can't understand product requirements or industry trends like I can."

The common thread: they haven't actually *seen* the frontier, so they're arguing with a version of the technology that stopped existing a year ago.

### Caste 2 — People who know it's here, but have no idea how to truly use it

- **2.1 — Developers** who know they *should* be using it, but are scared and intimidated. So they feel threatened, push back, and hope that if they complain loudly enough it'll go away. They think they can hold out until the fad passes. It isn't a fad, and they can't.
- **2.2 — Product** — same posture, same bet, same problem.

Caste 2 is the most dangerous place to be, because it *feels* like awareness. But awareness without practice is just anxiety with a better vocabulary.

### Caste 3 — On the right track, but still journeymen

- **3.1 — Developers** who know how to accelerate planning, have moved past one-off code-snippet generation, and are living in Cursor or Claude Code. What they don't know yet is how to *amplify* themselves. They're in between — no longer just a player with an instrument, not yet conducting an orchestra.
- **3.2 — Product** journeymen.

<!-- ⚠️ ELABORATE: 3.2 is a "fill this out" in the outline — currently a stub. Draft below is my PROPOSAL for your review, not your words yet. Confirm/rewrite:
Proposed 3.2: Product owners who have stopped fighting it and started using it — they draft requirements with Claude, use it to accelerate research, maybe generate a first-pass spec. But they still treat it as a smarter search box, not a team. They haven't learned to express intent as structured context an agent can execute against, and they still hand off to engineering the old way. One foot in the new world, one in the old. -->

### Caste 4 — Orchestrators: they can make the band play their music

- **4.1 — Developers** who can envision a *team* of agents that carries out their will:
  - They do it in a **token-efficient** way.
  - They **decompose goals into a parallel execution strategy**, track their agentic team, and orient it toward the vision.
  - They maintain **governance and observability** over the whole thing.
- **4.2 — Product** who are no longer doing the research themselves. They know how to express intent so that their expectations *materialize* as structured context — regulatory-requirement research, LLM-ready product requirements, and the rest. They have an idea, they agentically plan it, they tell Claude to build the PoC, and they're **git-basic ready** to commit and push what comes out.

Caste 4 isn't smarter than Caste 1. They just climbed.

## Climb the ladder

If you want to secure your future to the best of your ability, the move isn't to fight this. It's to prepare for it.

**I would rather conduct the train than be run over by it.**

Every rung you climb on the ladder of agentic readiness lessens your personal risk. You can never remove all of it — that's not how life works — but you can minimize it, deliberately, starting now. Pick your current caste. Then climb one rung. Then do it again.

The party's still going. The music's still cheap. That won't last. Learn to conduct before it stops.
