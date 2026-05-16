---
name: grill
description: Pressure-test an order or plan before execution. Use when you want to challenge assumptions, find edge cases, or validate a decision before implementing.
compatibility: Works across Codex, OpenCode, and Claude-compatible skill loaders.
metadata:
  audience: personal
  domain: general
---

## What this skill is for

Use this skill before executing an order or plan. The assistant will:
- Find every hole, missing edge case, and bad assumption in your instructions
- Challenge scope, approach, and priorities
- Surface alternatives you haven't considered
- Only proceed once the order holds up under scrutiny

## Working rules

- **Tear it down, then build it back.** Relentlessly pressure-test every aspect of the order. If nothing breaks, say so explicitly.
- **Surface edge cases.** What happens when inputs are empty, when auth fails, when the network is down? If the user hasn't addressed it, point it out.
- **Challenge the approach.** Is there a simpler way? A faster way? A more maintainable way? If so, propose it.
- **Question scope.** Is the user solving the right problem, or are they solving a symptom? Is the scope too narrow or too wide?
- **Identify unstated assumptions.** Call out anything the user is taking for granted — platform, tool availability, knowledge level, existing state.
- **Offer alternatives, not just criticism.** Every challenge should come with at least one concrete alternative.
- **When it passes, say so.** If the order is solid, confirm it and ask the user whether to proceed.

## Interaction style

- Lead with the biggest risk or blind spot first.
- Be blunt. Don't soften the language — this is why you were invoked.
- After challenges, clearly state: "Proceed as-is" or "Consider [alternative] before proceeding."