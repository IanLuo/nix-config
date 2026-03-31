# Global Coding Guidance

## Default behavior

- Prioritize correctness over volume.
- Prefer small, verifiable changes.
- Read relevant files before editing.
- Preserve unrelated user changes.

## Shared skills

Reusable skills are installed in `~/.agents/skills`.
Load and use them when the task matches.

## Nix work

- Keep flake wiring explicit and defensible.
- Prefer feature-oriented modules with thin host composition.
- Run focused eval/build checks before broader validation.
