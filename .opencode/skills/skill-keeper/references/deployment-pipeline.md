# Deployment Pipeline

How skills in this repo reach all AI agents on the machine.

## Source → Deploy Target

```
resources/ai/skills/<name>/SKILL.md    # source of truth (in this repo)
        ↓  nix build
/nix/store/xxx-ai-harness-skills/<name>/  # immutable store path
        ↓  home.activation (darwin-rebuild)
~/.agents/skills/<name>/                  # deployed (symlink from store)
        ↓  per-agent symlinks
~/.config/opencode/skills/<name>/         # opencode discovers these
~/.codex/skills/<name>/                   # codex discovers these
~/.claude/skills/<name>/                  # claude discovers these
```

## How It Works

1. `modules/ai-harness.nix` copies `resources/ai/skills/` into a Nix derivation
2. `home.activation.linkSharedSkills` runs on every `darwin-rebuild switch`
3. The activation script:
   - Removes stale symlinks (skills no longer in the derivation)
   - Creates fresh symlinks from the Nix store into `~/.agents/skills/`
   - Preserves non-symlink content (e.g., `.system/` managed by Codex)

## Adding a New Skill

1. Create `resources/ai/skills/<name>/SKILL.md`
2. Follow the skill-writing guide in `references/skill-writing.md`
3. Run `./scripts/setup.sh` to deploy
4. All agents discover it from `~/.agents/skills/`

## Removing a Skill

1. Delete `resources/ai/skills/<name>/`
2. Run `./scripts/setup.sh`
3. The activation script removes the stale symlink automatically

## Project-Local Skills

Skills in `.opencode/skills/` are project-local — only visible to opencode sessions in this repo. Not deployed globally. Use for project-specific tooling (like this skill-keeper).