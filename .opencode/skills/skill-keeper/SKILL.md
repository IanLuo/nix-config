---
name: skill-keeper
description: Create and maintain skills in this repo that deploy globally. Use when creating, editing, planning, or reviewing a skill.
compatibility: Works across Codex, OpenCode, and Claude-compatible skill loaders.
metadata:
  audience: personal
  domain: nix
---

## What this skill is for

Use this skill when creating, editing, or reviewing skills in this darwin config repo. Ensures skills follow conventions, are portable, and deploy correctly.

## Before you write anything

1. **Confirm intent with the user** — name, one-line description, target agents, the single problem it solves. Don't start writing until these are clear.
2. **Read references first** — load the relevant reference file before designing:
   - `references/skill-writing.md` — format, frontmatter, description rules
   - `references/philosophy-patterns.md` — design patterns from mattpocock/skills, superpowers, gstack
   - `references/deployment-pipeline.md` — how skills reach agents
3. **Check existing skills** — read skills already in `resources/ai/skills/` and `.opencode/skills/` before creating a new one. Compose, don't duplicate.

## Working rules

- **One skill, one job.** Each skill solves one failure mode or enables one workflow.
- **Description is discovery.** Agents pick skills by description alone. Include "Use when..." triggers. Max 1024 chars.
- **No agent-specific tool names.** Use "search the codebase" not "Glob/Grep". Different agents have different tools.
- **No hardcoded paths.** Skills must work on any machine after deployment.
- **SKILL.md under 100 lines.** Push details to `references/`.
- **Rules are actionable.** Every rule tells the agent what to DO, not what to know.
- **Name must match directory.** Skill in `my-skill/SKILL.md` must have `name: my-skill`.

## Where skills live

See `references/deployment-pipeline.md` for the full pipeline. Quick reference:

| Type | Location | Deploys globally? |
|------|----------|-------------------|
| Deployable | `resources/ai/skills/<name>/` | Yes, via `./scripts/setup.sh` |
| Project-local | `.opencode/skills/<name>/` | No, this repo only |

## After creating or editing a skill

1. **Validate frontmatter** — `name` matches directory, `description` has trigger words, under 1024 chars
2. **If deployable** — run `./scripts/setup.sh` and verify the skill appears in `~/.agents/skills/`
3. **If project-local** — restart the opencode session and verify the skill appears in the available skills list