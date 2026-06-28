---
title: 'Intelligence Moves Up the Stack'
description: "Agentic development isn't a chat window — it's a cognitive abstraction on top of one. Control just inverted again, all the way up to intent. The people who thrive are the ones who can turn intent into concrete, deterministic output."
pubDate: 'Jun 27 2026'
heroImage: 'https://images.unsplash.com/photo-1518770660439-4636190af475'
draft: false
hashtags: ['agenticdevelopment', 'softwareengineering', 'contextengineering']
series: 'Agentic Engineering'
seriesOrder: 4
socialQuote: "Intent without structure is a vibe. Intent with structure is a program."
---

There's a particular flavor of dread going around right now, and it isn't the one the headlines are selling. It's not "AI is going to replace developers." It's quieter and stranger than that.

I keep seeing strong, senior engineers say their workday has somehow become *less* fulfilling since they leaned into AI tools. One CTO put numbers on it that stuck with me: his split between high-judgment work and low-judgment work flipped from roughly 50/50 to something like 10/90. Not 90% *replaced* — 90% *glue*. Copy this into the chat window. Paste that back. Skim the diff. Approve this step, deny that one. Re-prompt. The interesting tenth was still his; the other nine-tenths had turned into being the wetware between a model and a clipboard.

His conclusion was the right one, and worth sitting with: the fix isn't *less* AI. It's *more* — automate the glue too. I want to pull on why that's true, because it points at something bigger than a workflow tip. It's about where intelligence lives in the stack — and the fact that it just moved again.

## The chat window is an interface, not an abstraction

Here's the thing that 90%-glue feeling is actually telling you: when you spend your day copy-pasting into a chat window, **you are the integration layer.** You're the bus the data rides on between your editor and the model and back. That doesn't feel like senior work because it isn't — it's hand-operating a seam that shouldn't need a human in it.

The chat UI is an *interface*. It is not the abstraction. It's a text box bolted onto something enormously powerful, and a text box you drive by hand is a rung, not a destination. The glue work is the symptom of a half-built abstraction — and of you standing one level too low to use the part that's already built.

## Intelligence has always moved up the stack

None of this is new. It's the oldest pattern in our field.

Once, the intelligence lived in hand-toggled machine code, and the people who mattered were the ones who could think in registers. Then it moved up to assembly, then to C, then to garbage-collected languages where you stopped hand-managing memory, then to frameworks where you stopped hand-writing the request loop. At every rung, the leverage climbed, and the rung below it stopped being something you operate by hand and became something you *stand on*. Nobody senior is out here hand-allocating registers to feel fulfilled. We let that drop beneath us and went up.

Agentic development is the next rung. It's a **cognitive abstraction that sits on top of the chat interface and operates it for you** — the layer that does the copy-pasting, the re-prompting, the diff-skimming, the allow/deny, so you don't have to be the bus. The CTO who said "automate the glue" was describing exactly this: the move up the stack, one more time.

## We've done this before — it's just Inversion of Control, all the way up

If you've written software for a living, you already have the mental model for what's happening, because we built our whole craft around it.

We spent careers learning *not* to call our dependencies directly. SOLID. Program to an interface, not an implementation. Dependency inversion. The Hollywood Principle — "don't call us, we'll call you." Inversion of Control felt, the first time, like giving something up: you stop being the thing that orchestrates and start being a thing that gets orchestrated. But that was never a loss of control. It was a move *up a level of abstraction* — you traded operating the wiring for declaring the shape.

Agentic development is that same move, one final time, at the top of the stack. **Control inverts again — and this time it inverts to intent.** You don't call the functions. You increasingly don't even write the prompts by hand. You declare what you want to be true, and the agent becomes the runtime that resolves it. Don't call us, we'll call you, now runs between *you and the machine*: you state the *what*, it works out the *how*.

## But inverted control only works if the interface is precise

And here's the catch the SOLID analogy makes impossible to miss.

Inversion of Control only works because the **interface is well-defined.** "Program to an interface" is worthless if the interface doesn't actually pin down the contract. Invert control toward a vague interface and you don't get elegance — you get chaos that's now also hard to debug.

Intent is the same. Invert control toward a *vague* intent and you get the slot machine — a different plausible-looking result every pull. The people who are going to thrive in this aren't the ones with the most ambitious intent. They're the ones who can express intent as a **contract**: concrete, bounded, and reproducible — the [same way twice](/blog/the-same-way-twice/). Intent without structure is a vibe. Intent *with* structure is a program. That's the entire game, and it's why [structured context, not raw model capability, is the bottleneck](/blog/easy-bake-oven-developers/) — the abstraction at the top of the stack is only as good as the precision of the intent you hand it.

## So the 90% glue isn't the future — it's a sign you're standing too low

Now go back to the dread. The 90%-glue day feels like the job degrading. It's actually the job pointing *up*.

Copy-paste, babysitting, approve-this-deny-that — that is integration work between you and the chat interface, which means you're hand-operating a rung the leverage already left. The answer isn't to grind the glue harder, and it isn't to quit in disgust because the work stopped feeling smart. It's to **climb.** Stop being the integration layer; become the intent layer. Automate the glue — the CTO was right — and spend your judgment on the one thing that *doesn't* move up the stack: deciding what should be true, and specifying it precisely enough that a machine can make it true, reproducibly.

## The honest version

Intelligence moves up the stack. It always has. And at every previous rung, the people who thrived were the ones who climbed with it instead of clinging to the level below — not the assembly diehards, not the "real engineers don't use frameworks" holdouts. They were right that something was being abstracted away. They were wrong that it was the part that mattered.

This rung is no different, with one twist: the new top-of-stack skill isn't a language or a framework you can grind into muscle memory. It's the ability to take what's in your head and turn it into a concrete, deterministic output a machine can execute the same way twice. That's it. That's the whole job now.

So the only question that matters: are you climbing to the intent layer — or are you still the glue? I'd genuinely like to hear from people on either side of that, especially anyone who felt the 90%-glue slump and found their way up out of it.
