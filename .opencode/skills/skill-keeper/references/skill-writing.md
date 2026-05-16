# Skill Writing Guide

Derived from mattpocock/skills `write-a-skill` pattern and lessons across skill systems.

## SKILL.md Structure

```
skill-name/
├── SKILL.md           # Main instructions (required)
├── references/        # Supplementary docs (optional)
│   └── *.md
└── scripts/           # Utility scripts (optional)
    └── helper.sh
```

## Frontmatter

```yaml
---
name: skill-name          # required, must match directory name, lowercase-hyphenated
description: ...          # required, max 1024 chars, include trigger words
compatibility: ...        # optional, e.g. "Works across Codex, OpenCode, and Claude"
metadata:                # optional, string-to-string map
  audience: personal
  domain: general
---
```

## Description Rules

The description is ALL the agent sees when deciding whether to load this skill. It must:

1. State what the skill does in one sentence
2. Include "Use when..." with specific trigger words
3. Stay under 1024 characters
4. Be specific enough to distinguish from other skills

Good: "Create and maintain skills for the portable AI harness. Use when creating, editing, or reviewing skills in this repo."

Bad: "Helps with skills."

## Content Rules

- **SKILL.md under 100 lines.** Split to `references/` if longer.
- **Rules are actionable.** Every rule tells the agent what to DO, not just what to know.
- **No agent-specific tool names.** Use generic descriptions: "search the codebase" not "use Glob/Grep". Different agents have different tools.
- **No hardcoded paths.** Skills should be portable across machines.
- **Progressive disclosure.** Quick start first, advanced features via references.
- **Include "Use when..." triggers** in the description and in the body.

## When to Add Scripts

- Operation is deterministic (validation, formatting, transformation)
- Same code would be generated repeatedly
- Errors need explicit handling
- Scripts save tokens and improve reliability vs generated code

## Review Checklist

- [ ] Name matches directory name
- [ ] Description includes trigger words ("Use when...")
- [ ] Description under 1024 chars
- [ ] SKILL.md under 100 lines
- [ ] No agent-specific tool names
- [ ] No hardcoded paths
- [ ] Rules are actionable instructions
- [ ] Compatibility field lists intended agents