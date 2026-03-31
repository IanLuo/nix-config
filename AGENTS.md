# AGENTS.md

## Purpose

This repository is a Nix flake for personal environment management across:

- macOS via `nix-darwin`
- standalone Linux Home Manager
- NixOS

Agentic coding assistants should treat it as a configuration repo, not an application repo.
Most changes are module wiring, package selection, shell automation, or editor configuration.

## Rule Sources

- No `.cursor/rules/` directory was found.
- No `.cursorrules` file was found.
- No `.github/copilot-instructions.md` file was found.
- No repo-level `CONVENTIONS.md` was found.
- No repo-level `.editorconfig` was found.

Follow the guidance in this file and the existing code patterns in the repo.

## Architecture: The Dendritic Pattern

This repository follows the **dendritic pattern** (see `github.com/mightyiam/dendritic`).
Every `.nix` file under `modules/` (except entry points) is a `flake-parts` module that
registers itself directly into the top-level flake evaluation. `import-tree` auto-discovers
and loads all such files — there is no manual import list to maintain.

Key properties:
- Every non-entry-point `.nix` file under `modules/` is a `flake-parts` module.
- Modules are **feature-centric**: a single file covers all configuration classes for one
  feature (e.g. `window-management.nix` defines both darwin and nixos variants together).
- Cross-cutting values are shared via the top-level `config.*` namespace
  (e.g. `config.repo.*`), not via `specialArgs` threading.
- `flake.nix` is a pure inputs manifest + one-liner entrypoint. Keep it that way.

### The `_` prefix convention

Files and directories under `modules/` whose path contains a `/_` segment are **excluded**
from auto-import by `import-tree`. Use the `_` prefix for:
- Non-module support files co-located with a host (e.g. `modules/hosts/_nixos-vm/`)
- Any `.nix` file that is imported explicitly by another module rather than the tree root

Do not put files under `modules/` that are plain Nix expressions rather than flake-parts
modules, unless they live under a `_`-prefixed path.

## Repository Layout

```
flake.nix                          # inputs manifest + mkFlake one-liner
flake.lock
modules/
  repo.nix                         # flake-level repo helpers (mkPkgs, stateVersion, etc.)
  checks.nix                       # flake checks and NixOS VM smoke test
  hosts/
    ianluo.nix                     # Darwin host: darwinConfigurations.ianluo
    ian-linux-dev.nix              # Linux HM host: homeConfigurations.ian-linux-dev
    nixos-vm.nix                   # NixOS host: nixosConfigurations.nixos-vm
    _nixos-vm/
      hardware-configuration.nix   # NixOS VM hardware config (not a flake-parts module)
  # Feature modules (each covers all platforms it applies to):
  home-base.nix                    # HM base: stateVersion, EDITOR
  system-packages.nix              # HM: installs the shared package set
  cli.nix                          # HM: CLI tools (fzf, htop, git, tmate, ...)
  shell.nix                        # HM: zsh + oh-my-zsh + powerlevel10k
  tmux.nix                         # HM: tmux configuration
  editor.nix                       # HM: neovim + LSPs + plugins
  ai-home.nix                      # HM: AI agent tools (codex, opencode, claude, gstack)
  system-foundation.nix            # Darwin + NixOS: nix daemon, caches, GC
  window-management.nix            # Darwin (yabai/skhd) + NixOS (xfce+i3)
  remote-access.nix                # NixOS: openssh
packages/
  custom/                          # Custom package derivations (one file per package)
  default.nix                      # Assembles the full package set
  stable.nix / unstable.nix / darwin.nix
programs/
  vim/                             # Neovim Lua config files (not Nix modules)
  zsh/                             # zsh config files (p10k, etc.)
resources/
  ai/
    skills/                        # First-party shared AI agent skills
    instructions/                  # Per-agent global instruction files
scripts/                           # rebuild, update, inspection helpers
nixos/                             # Legacy NixOS compatibility shim (unused by flake)
```

## Primary Flake Outputs

- Darwin: `.#darwinConfigurations.ianluo`
- Linux Home Manager: `.#homeConfigurations.ian-linux-dev`
- NixOS: `.#nixosConfigurations.nixos-vm`

## Core Commands

## Validation

- Full validation: `nix flake check --all-systems`
- Show outputs: `nix flake show`
- Evaluate flake without building: `nix eval .#darwinConfigurations.ianluo.config.system.build.toplevel.drvPath`

## Build Commands

- Build Darwin system: `nix build .#darwinConfigurations.ianluo.config.system.build.toplevel`
- Build Linux HM activation package: `nix build .#homeConfigurations.ian-linux-dev.activationPackage`
- Build NixOS system: `nix build .#nixosConfigurations.nixos-vm.config.system.build.toplevel`

## Apply Commands

- macOS apply: `./scripts/setup.sh`
- macOS explicit target: `DARWIN_CONFIG_NAME=ianluo ./scripts/setup.sh`
- Linux HM apply: `HOME_CONFIG_NAME=ian-linux-dev ./scripts/setup.sh`
- NixOS apply: `sudo NIXOS_CONFIG_NAME=nixos-vm ./scripts/setup.sh`
- Compatibility wrapper: `./scripts/rebuild.sh`

## Single-Test / Focused Test Commands

There is no traditional unit test framework here.
Use focused flake checks or targeted builds instead.

- Run one Darwin invariant check: `nix build .#checks.aarch64-darwin.darwin-invariants`
- Run one Linux HM invariant check: `nix build .#checks.aarch64-darwin.linux-home-invariants`
- Run one NixOS invariant check: `nix build .#checks.aarch64-darwin.nixos-invariants`
- Run the NixOS VM smoke test derivation: `nix build .#checks.aarch64-linux.nixos-vm-smoke`
- Evaluate one option: `nix eval .#darwinConfigurations.ianluo.config.system.primaryUser`
- Evaluate one HM option: `nix eval .#homeConfigurations.ian-linux-dev.config.home.homeDirectory`

## Script Validation

- Syntax-check one shell script: `bash -n scripts/setup.sh`
- Syntax-check several scripts: `bash -n scripts/setup.sh && bash -n scripts/update-all.sh`

## Formatting

- Preferred formatter: `nix fmt`
- Direct formatter form: `nix run .#formatter.aarch64-darwin`

## Update / Maintenance Commands

- Update all inputs: `./scripts/update-all.sh`
- Update current nixpkgs input: `./scripts/update-stable.sh`
- Placeholder unstable update flow: `./scripts/update-unstable.sh`
- Show input status: `./scripts/package-status.sh`
- Manage bleeding-edge packages: `./scripts/bleeding-edge.sh`

## Platform Notes

- Darwin builds can be fully built locally on this machine.
- Linux and NixOS outputs can be evaluated on Darwin, but full builds may require a Linux builder.
- Do not assume a Linux-target build will succeed locally on macOS.
- Prefer `nix flake check --all-systems` when cross-platform confidence is needed.

## Nix Style Guidelines

- Use 2-space indentation.
- End attribute sets and lists with trailing semicolons or brackets in the existing style.
- Keep module arguments minimal and explicit, e.g. `{ pkgs, lib, ... }:`.
- Prefer small helper bindings in `let` blocks when expressions are reused.
- Keep `flake.nix` boring: it is a pure inputs manifest + one-liner. No logic lives there.
- Feature modules are the unit of organization: one file per feature, all platforms together.
- Host files (`modules/hosts/*.nix`) are thin entrypoints: they declare flake outputs and
  compose feature modules. They should not contain feature logic.
- Use `config.repo.*` for shared values accessible across all modules (stateVersion, mkPkgs,
  etc.). Do not re-thread these via `specialArgs`.
- Use `pkgs.stdenv.hostPlatform.system` instead of deprecated `pkgs.system`.
- Use assertions for invariants that should fail evaluation early.
- New files added under `modules/` are automatically imported by `import-tree`. If a file
  should NOT be a flake-parts module, place it under a `_`-prefixed path segment.

## Package / Module Conventions

- Custom package derivations live in `packages/custom/` (one file per package).
- `packages/default.nix` assembles the full package set from stable, unstable, darwin, and
  custom subsets.
- `nixpkgs` is the default source of truth for packages.
- Use plain `pkgs.<name>` when the packaged version in `nixpkgs` is acceptable.
- If a package must be sourced from a separate flake input, declare the input in `flake.nix`
  and build the package via `pkgs.callPackage` inside the relevant module. Keep inputs as
  source declarations only — do not reference `inputs.*` from install lists.
- Each tool must have one canonical package symbol across the repo.
- Keep package selection separate from package definition.

## AI Home Conventions (`ai-home.nix`)

- `programs.aiHome.shared.*` — skill tree, instruction files, supported agents
- `programs.aiHome.adapters.*` — per-agent configuration (codex, claude, opencode)
- `programs.aiHome.sources.*` — external skill bundles (e.g. `sources.gstack`)
- Skills are assembled into `~/.agents/skills`; per-agent symlinks fan out from there.
- `sources.gstack.enable` controls whether the gstack skill bundle is included.
- First-party skills live in `resources/ai/skills/`.
- Per-agent global instruction files live in `resources/ai/instructions/<agent>/`.

## Shell Script Guidelines

- Use `#!/usr/bin/env bash`.
- Use `set -euo pipefail`.
- Quote paths and variable expansions.
- Prefer helper functions for non-trivial branching.
- Prefer repository-relative path discovery via `SCRIPT_DIR`.
- Fail with clear stderr messages when required tools are missing.
- Keep scripts aligned with actual flake output names; do not assume username == flake target.

## Lua / Neovim Guidelines

- Follow the existing Lua style in `programs/vim/config/lua/`.
- Use local bindings for shared values like capabilities and callbacks.
- Keep plugin setup blocks compact and direct.
- Prefer matching the surrounding quote style and table style in the file you edit.
- Do not add new formatting conventions unless the file already uses them consistently.

## Naming Conventions

- Feature modules: descriptive lowercase file names matching the feature (e.g. `shell.nix`,
  `editor.nix`, `window-management.nix`)
- Flake outputs: explicit host-oriented names like `ianluo`, `ian-linux-dev`, `nixos-vm`
- Repo helpers: `mkPkgs`, `mkStablePkgs`, `mkUnstablePkgs`, `mkSystemPackages`
- Shell scripts: verb-based names like `setup.sh`, `update-all.sh`, `bleeding-edge.sh`

## Error Handling Expectations

- Prefer evaluation-time failures for invalid config shape.
- Add or preserve assertions when a bad state should never be applied.
- In shell, print actionable error messages before exiting.
- Do not swallow errors unless there is a deliberate fallback.
- If a fallback is intentional, make it obvious in output.

## Change Management

- Preserve unrelated user changes.
- Do not revert or overwrite work you did not make.
- Keep unrelated edits in separate commits when practical.
- When changing scripts or docs, update both if behavior changes.
- When changing flake/module wiring, rerun focused validation plus `nix flake check --all-systems`.

## Good Agent Workflow

1. Read the relevant host and module files before editing.
2. Prefer minimal structural changes that follow the dendritic feature-module pattern.
3. Validate the smallest affected target first (single `nix eval` or focused check).
4. Then run broader checks if the change touches shared wiring.
5. Summarize platform limitations honestly, especially for Linux builds on Darwin.
