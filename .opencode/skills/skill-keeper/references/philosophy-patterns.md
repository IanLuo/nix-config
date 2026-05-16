# Skill Philosophy Patterns

Patterns observed across mattpocock/skills, obra/superpowers, and gstack.

## mattpocock/skills

Small, composable, adaptable. Built on decades of engineering practice.

**Core idea:** Skills fix specific agent failure modes:
- **Misalignment** → grill-me / grill-with-docs (challenge the plan before coding)
- **Verbosity** → shared language / CONTEXT.md (define jargon once, reuse everywhere)
- **No feedback** → TDD skill (red-green-refactor loop)
- **Ball of mud** → improve-codebase-architecture (deepening opportunities)

**Key patterns:**
- Skills are small (under 100 lines in SKILL.md)
- References live in separate files, loaded on demand
- Each skill solves ONE failure mode
- The description is the discovery mechanism — agents pick skills by description alone
- Skills compose: grill-me + TDD + diagnose = disciplined engineering workflow
- `write-a-skill` is a meta-skill for creating other skills

**Skill types:**
- Productivity (grill-me, handoff, write-a-skill)
- Engineering (tdd, diagnose, zoom-out, improve-codebase-architecture, to-prd, to-issues)
- Setup (setup-matt-pocock-skills — configures per-repo settings)

## obra/superpowers

Mandatory workflows, not suggestions. Skills trigger automatically based on context.

**Core idea:** The agent shouldn't just suggest — it should enforce process:
1. brainstorming → 2. design → 3. planning → 4. execution → 5. review

**Key patterns:**
- Skills are MANDATORY, not optional. The agent checks for relevant skills before every task.
- Subagent-driven development: dispatch fresh agents per task with two-stage review
- Heavy use of `references/` for detailed docs (testing anti-patterns, root cause tracing)
- The `writing-skills` skill is a meta-skill for creating new skills

**Differences from mattpocock:**
- Superpowers enforces workflow; mattpocock skills are opt-in per invocation
- Superpowers has more opinionated structure (must follow the process)
- Superpowers includes git worktree management as a skill

## gstack

CLI-first skill system. Each skill is a subcommand (`/qa`, `/ship`, `/review`, etc.).

**Key patterns:**
- Skills wrap deterministic CLI tools (the skill shells out to scripts)
- `agents/openai.yaml` registers slash commands for Codex
- Skills are invoked as `/command-name` rather than loaded as context
- Parameters are passed as arguments (`/qa https://staging.example.com`)

**Differences:**
- CLI-first vs instruction-first (mattpocock/superpowers are instruction packs)
- Requires executable scripts, not just markdown
- Better for repeatable deterministic tasks (QA, deploy, review)
- Worse for open-ended reasoning (brainstorming, architecture)

## Takeaways for this harness

1. **Small and composable** — each skill solves one problem
2. **Description is king** — agents discover skills by description alone
3. **References for depth** — keep SKILL.md under 100 lines, push details to references/
4. **Portable tool references** — no agent-specific tool names
5. **Deployed globally** — skills in this repo ship to all agents via nix-darwin