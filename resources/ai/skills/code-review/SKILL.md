---
name: code-review
description: Use when reviewing code changes for bugs, regressions, missing validation, behavior changes, and maintainability risks.
compatibility: Works across Codex, OpenCode, and Claude-compatible skill loaders.
metadata:
  audience: coding-agents
  domain: review
---

## Primary focus

Find concrete problems first:

- logic errors
- behavioral regressions
- missing validation
- broken assumptions
- missing tests for changed behavior

## Review method

- Read the changed file in context, not only the diff.
- Verify that wiring changes are actually passed through the evaluation boundary.
- Be explicit about the scenario that causes the bug.
- Separate true bugs from style preferences.

## Output format

- Findings first, ordered by severity.
- Include file references.
- Keep summaries short.
