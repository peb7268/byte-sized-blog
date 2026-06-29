---
title: 'Terms I Need to Know'
description: "The whole catalog leans on a handful of words and assumes you already have them. This is the on-ramp's on-ramp — an opinionated field guide to the vocabulary you need before the rest of the series lands."
pubDate: 'Jun 29 2026'
draft: true
series: 'Agentic Foundations'
seriesOrder: 1
tags: ['agentic-ai', 'fundamentals', 'vocabulary']
hashtags: ['agenticdevelopment', 'aiengineering', 'fundamentals']
---

Every post I write in this series stands on a small pile of words I never stop to define. Agent. Context window. Harness. MCP. I use them the way a carpenter says "joist" — assuming the room already knows. And then someone smart, who is *not* steeped in this stuff every day, reads it and quietly bounces off the third paragraph because I never told them what a token is.

So before the rest of the series can land, I owe you the vocabulary. Not a dictionary — a field guide. For each term I'll give you the crisp definition *and* the part the definition usually leaves out: why it matters, where people get it wrong, what changes once you actually internalize it.

This is the on-ramp's on-ramp. If you only read one post in the Foundations series first, read this one.

## Agent

Start here, because the word is doing a lot of work and most people use it wrong.

An **agent** is a system that's given a goal and the autonomy to take *actions* toward it — reading files, running commands, calling tools, looping on its own output — until the goal is met or it gives up. The key word is *actions*. It doesn't just talk back; it does things to the world and reacts to what happens.

That's what separates it from the things it gets confused with. A **chatbot** answers a question and stops — one turn, no hands. **Autocomplete** (think old-school Copilot) finishes the line you're typing — it's a suggestion engine, not a goal-seeker. A **copilot** sits beside you and helps while *you* stay in the driver's seat. An agent takes the wheel. The honest mental model is a junior contractor you can hand a task to and walk away from for ten minutes — not a smarter search box. Once you feel that difference in your gut, half of the hype and half of the fear sort themselves out.

## Context window

A language model has no memory. None. It doesn't remember you, your codebase, or what it did thirty seconds ago. It has exactly one input: the block of text you hand it *this turn*. That block — everything the model can see at once — is the **context window**.

I'm going to write a whole post on this (*Context Is King*, coming in this same series), because it's the most important concept here and the most underrated. The short version: think of the model as a brilliant contractor with total amnesia, handed a single manila folder before each task. Whatever's in the folder, they use. Whatever's missing, they invent or ignore. The folder is the entire world. Get good at what goes in the folder and everything downstream gets easier.

## Tokens

The context window has a finite size, measured in **tokens**. A token is a chunk of text — roughly three-quarters of a word, give or take. "Cat" is one token; "tokenization" might be three.

Why you should care: tokens are the unit of *both* cost and capacity. You pay per token, and the window holds a fixed number of them. Everything competes for that space — your instructions, the files you loaded, the conversation so far, the tool outputs. When people say a model "got dumber" halfway through a long session, what usually happened is the window filled with noise and the signal got buried, or it overflowed and the earliest pages fell out the back. Tokens are the budget you're always secretly spending.

## Harness

The model is just the engine. The **harness** is everything wrapped around it that turns raw text-prediction into useful work: the loop that feeds it context, runs the tools it asks for, captures the results, and feeds them back. Claude Code, Cursor, the agent framework you wired up yourself — those are harnesses.

This is the term people skip, and skipping it causes a specific confusion: blaming the model for what's actually the harness's job. "The AI couldn't see my other file" — that's not the model, that's the harness failing to load it. "The AI ran the wrong command" — harness. The model is shockingly consistent; the harness is where most of your real-world experience is actually determined. Knowing the difference tells you *what to go fix.*

## MCP (the tool protocol)

**MCP** — the Model Context Protocol — is a standard way to plug tools and data sources into an agent. Think of it as USB for AI: a common plug so any compliant tool (a database, your Jira, a file system, a browser) can be exposed to any compliant agent without bespoke glue code each time.

Why it matters more than it sounds: before a shared protocol, every tool integration was a one-off. MCP is what makes the ecosystem *composable* — you can hand your agent a new capability by connecting a server, not by rewriting the agent. When I say an agent "has access to Jira," I almost always mean someone connected an MCP server. It's plumbing, but it's the plumbing that decides what your agent can actually reach.

## Tool use

**Tool use** is the mechanism underneath all of that: the model, instead of just emitting prose, emits a structured request — "call `search_files` with this argument" — and the harness runs it and returns the result.

This is the thing that makes agents *agents*. Without tool use, a model can only describe how it would read your file. With tool use, it actually reads it, sees the contents, and decides what to do next. Every capability you find impressive — editing code, querying a database, browsing the web — is tool use plus a loop. It's the bridge from talking about the world to acting on it.

## Subagent

A **subagent** is an agent spun up by another agent to handle a focused piece of work, with its own fresh context window, that reports a result back to the caller.

The reason this exists is the context window again. A long, messy task pollutes the folder — by step twelve it's crammed with the debris of steps one through eleven. A subagent gets a clean folder, does one bounded job ("review this file for security bugs"), and hands back only the *conclusion*, not the mess. It's the same instinct as delegating to a focused colleague instead of keeping every detail in your own head. Used well, it's how you keep big tasks from drowning in their own noise.

## Prompt vs spec

A **prompt** is what you type in the moment — a request, an instruction, a question. A **spec** is a durable, structured statement of *intent*: what "done" means, the constraints, the acceptance criteria, the edge cases — written to be handed to an agent (or a person) and executed against.

The difference is permanence and rigor. A prompt is a conversation; a spec is a contract. As execution gets cheap and agents get capable, the spec becomes the actual artifact of value — the thing you labor over — because a vague spec produces confident, plausible, wrong work. I dig into this in [Anatomy of a Spec](/blog/anatomy-of-a-spec/). For now just hold the distinction: prompting is talking, specifying is engineering.

## Orchestration

**Orchestration** is coordinating multiple agents (or multiple steps, or multiple tools) toward a larger goal — deciding what runs when, what hands off to what, what runs in parallel, and how the pieces combine.

This is the altitude the job is climbing to. When one agent can write the code, your leverage isn't writing code anymore — it's arranging the agents that do, the way a conductor doesn't play an instrument but decides what the whole orchestra does. It's the through-line of [The Review Is the Work Now](/blog/the-review-is-the-work-now/) and [Intelligence Moves Up the Stack](/blog/intelligence-moves-up-the-stack/), and it gets its own full treatment in [Orchestration](/blog/orchestration/). The short version: you're becoming a conductor whether you signed up for it or not.

## Eval

An **eval** is a test for non-deterministic systems — a structured way to measure whether an agent's output is actually good, run repeatably, so you can tell if a change made things better or worse.

Here's why it's non-negotiable: agents don't fail like normal software. They don't throw an exception, they just quietly produce something subtly wrong and say it with total confidence. A green unit test won't catch "this summary is plausible but misleading." Evals are how you get a grip on quality you can't eyeball at scale — your regression suite for judgment. If you're building anything real with agents and you don't have evals, you don't actually know if your last change helped. You're guessing.

## OI vs AI

Last one, and it's mine. **OI — Organic Intelligence** — is the hands-on-keyboard understanding you accrue by building a thing yourself, line by line, mistake by mistake: the model of the system that lives in your head precisely because you grew it. **AI** is the thing you're now delegating that building to.

I introduced this in [The Review Is the Work Now](/blog/the-review-is-the-work-now/) because the whole anxiety of this moment is a migration from leaning on OI to leaning on AI — speed pulling one way, comprehension pulling the other. I keep the two letters distinct on purpose, all through the series, because the central question of agentic work is *how much of your OI you're willing to trade for AI's speed, and how you keep the OI from quietly rotting while you do.* That tension is the subject under all the other terms.

## That's the toolkit

Agent, context window, tokens, harness, MCP, tool use, subagent, prompt vs spec, orchestration, eval, OI vs AI. Eleven words. Internalize them and the rest of this series reads like plain English instead of jargon.

I'll keep using them as if they're obvious — because now, for you, they are. Next stop: the one that matters most. Context, it turns out, isn't the setting for the work. It *is* the work.
