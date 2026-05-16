---
name: handoff
description: Extract a compact, facts-only summary from the current session so a fresh session can continue the work. Use when wrapping up, switching agents, or needing to resume work in a new conversation.
compatibility: Works across Codex, OpenCode, and Claude-compatible skill loaders.
metadata:
  audience: personal
  domain: general
---

## What this skill is for

Produce a concise handoff document from the current session. A new agent reading only this document must be able to pick up where you left off without guessing.

## Working rules

1. **Scan the full session.** Review every exchange from the beginning. Do not skim.
2. **Extract only facts.** Drop greetings, clarifications that were resolved, failed attempts, and tangents. Keep what remains.
3. **Structure the handoff as four sections:**
   - **Done:** What was completed. List concrete outcomes, not intentions.
   - **In progress:** What was started but not finished. Include exact file paths, line numbers, and current state.
   - **Blocked / open questions:** Unresolved issues, missing inputs, or decisions that need a human.
   - **Parameters to resume:** repo path, branch, relevant file paths, env vars, tool versions — anything a new session needs to reproduce context.
4. **No narrative.** Write bullet points, not paragraphs. Each bullet is one fact.
5. **No repetition.** If a fact appears in Done, do not repeat it in Parameters.
6. **Include errors that matter.** If something failed and the failure changed the plan, note the error and the workaround or decision that followed. Skip transient failures that were retried successfully.
7. **Verify file paths.** Every path in the handoff must exist at the time you write it. Do not include paths you assume exist but haven't confirmed.
8. **Output the handoff as the last message.** The user should be able to copy-paste it directly into a new session.

## Format

```
## Handoff: <one-line topic>

### Done
- ...

### In progress
- ...

### Blocked / open questions
- ...

### Parameters to resume
- ...
```