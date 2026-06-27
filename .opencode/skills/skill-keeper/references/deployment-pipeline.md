# Deployment Pipeline

Skills in this repo are project-local only. Global deployment via Nix has been removed.

## Where Skills Live

| Type | Location | Scope |
|------|----------|-------|
| Project-local | `.opencode/skills/<name>/` | This repo only |

## Adding a New Skill

1. Create `.opencode/skills/<name>/SKILL.md`
2. Follow the skill-writing guide in `references/skill-writing.md`
3. Restart the opencode session to pick it up

## Removing a Skill

1. Delete `.opencode/skills/<name>/`
2. Restart the opencode session

## Previous Global Deployment (Removed)

The previous `resources/ai/skills/` → Nix store → `~/.agents/skills/` pipeline was removed. All skills are now project-local under `.opencode/skills/`.
