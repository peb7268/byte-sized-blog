---
title: 'Easy Bake Oven Developers'
description: "There's a kind of developer who treats AI like a toy oven — toss in random ingredients, expect a finished cake, and blame the appliance when it doesn't work. The problem was never the model. It's GIGO, and it's a mental-model problem."
pubDate: 'Jun 27 2026'
heroImage: 'https://images.unsplash.com/photo-1495147466023-ac5c588e2e94'
draft: false
tags: ['vibecoding', 'agenticdevelopment', 'asdlc']
---

In the [last piece](/blog/the-same-way-twice/) I argued that the real deliverable from an agent isn't capability, it's *reproducibility* — doing the task the same way twice — and that you get there by feeding it a structured spec instead of a vibe. I want to stay on that thread, but come at it from the human side. Because the spec problem is really a *mental model* problem, and the broken mental model has a shape I can't unsee anymore.

It looks like an Easy Bake Oven.

## The toy that looked like the real thing

If you grew up in a certain era, you or a sibling had one. A pastel plastic box with a lightbulb inside, a slot for a little pan, and a packet of pre-measured mix. You added a splash of water, slid the pan in, waited, and pulled out a warm, genuinely-edible miniature cake. It felt like magic — a real oven, shrunk to kid scale.

Except it wasn't an oven. It was a toy that *simulated* one, and it worked under exactly one condition: you used the packet. The whole thing was engineered around a narrow, structured input. Try to freelance — dump in flour and tap water and ambition, or ask it to roast anything — and you got a lightbulb-warmed disappointment. Not because the toy was broken. Because you fed it garbage and expected the box to make up the difference.

I've been thinking about that toy constantly, because I keep meeting developers who treat AI exactly like one.

## A real engineer with a toy's expectations

Here's the part that makes this worth writing about: these aren't vibe coders. Vibe coders never claimed to care about structure — they're cheerfully along for the ride, and they're a different conversation. The people I'm talking about are *actual developers*. Skilled ones. People who would never, ever expect to pipe `/dev/random` into a compiler and get a working binary.

And yet they sit down with a genuinely powerful agent, throw in a half-sentence prompt and a random pile of unstructured context — three open files, a vague "make it better," none of the constraints, none of the acceptance criteria, none of the *intent* — and they expect a finished, structured, correct result to come out the other side. The Easy Bake fantasy: heat plus mystery powder equals cake.

When it doesn't work, watch what they do. They don't interrogate the input. They blame the oven. "See? AI writes garbage." They tossed flour and tap water into a toy and concluded the appliance is a fraud.

## GIGO never went anywhere

Garbage in, garbage out is the oldest law in computing, and it did not get repealed when the input became English. If anything the natural-language interface is what tricked everyone into forgetting it. A prompt *feels* like a conversation, so people stop treating it like an input. They'd spend an hour shaping a function signature and then hand the model a sentence they wouldn't accept in a Slack message, and call the result evidence.

The model is doing precisely what you'd expect a powerful, context-hungry system to do with a context-starved request: it fills the vacuum with its best guess. Structured context in, tangible result out. Random context in, plausible-looking mush out. The capability was never the variable. *You* were the variable, the whole time.

## A field guide to how developers are taking this

Sort the room and you get roughly four kinds of developer right now:

1. **The unaware.** They don't quite see what's happening, or they've decided it's overblown — autocomplete with a marketing budget. Not wrong about the hype; very wrong about the floor moving under them.
2. **"AI just writes bad code."** They tried it. They got bad code. Case closed.
3. **"I write better code than AI."** They tried it, compared the model's one-shot reply to their own careful, contextful work, and declared victory.
4. **The agentic engineer.** Already riding the wave — and quietly compounding while the other three argue.

Here's the uncomfortable read: archetypes 2 and 3 are usually Easy Bake Oven Developers in disguise. The "AI writes bad code" crowd fed a toy a random handful of ingredients and graded the cake. The "I'm better than AI" crowd ran an unfair race — *their* structured effort, their full mental model and context and care, against the model's reply to a one-line prompt. Of course they won. They brought a recipe to a fight they'd set up so the model couldn't. The conclusion they drew ("I'm better") is the wrong lesson hiding the right one: structured input wins. They just happened to be the only one in the room supplying it.

Archetype 1 is mostly a timing problem; it resolves itself. Archetype 4 figured out the only thing that actually matters here, which is that the structured context *is* the work.

## The agentic engineer puts the recipe in

The difference between the EBO developer and the agentic engineer isn't talent and it isn't the model — they're using the same tools. It's that one of them brings a recipe and the other brings vibes and a grievance.

The agentic engineer treats context as the deliverable. They write the spec — inputs, outputs, invariants, the explicit non-goals — the same [score I talked about last time](/blog/the-same-way-twice/) that collapses a model's cloud of possible behaviors down to the point you actually wanted. They hand the agent the constraints, the examples, the shape of the solution, the *why*. And then, unsurprisingly, they get tangible, reproducible results — not because their model is better, but because their *input* is. They stopped expecting the oven to invent the recipe.

This is the same idea I keep circling from different sides. [The review is the work now](/blog/the-review-is-the-work-now/) because your judgment is the scarce input. Reproducibility comes from a spec because structure is what pins behavior. And here it is again from the front of the pipeline: the quality of what comes out is governed almost entirely by the structure of what you put in. Same law, three windows.

## The oven was never the toy

The thing that gets me about Easy Bake Oven Developers is that they're *right there*. They have the skills. They have the tools — the exact same tools as the people running circles around them. The only thing standing between them and archetype 4 is a mental model: the belief that a sufficiently powerful system should turn randomness into structure for free, and that if it doesn't, the system is the problem.

It isn't. The oven was never the toy. The toy was the expectation that you could skip the recipe.

So I'll ask the question I actually care about: when an agent gives you garbage, what's your first move — do you go diff *your input*, or do you reach for "AI writes bad code"? Because that reflex, more than any benchmark, is the line between the developers who compound with this stuff and the ones who spend the next few years insisting the oven is broken. I'd genuinely like to hear which way people break, and what finally flipped the ones who crossed over.
