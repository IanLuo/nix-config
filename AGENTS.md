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

## Repository Layout

- `flake.nix`: main flake entrypoint
- `hosts/`: host entrypoints for Darwin, Linux HM, and NixOS
- `modules/shared/`: shared package and home-manager modules
- `modules/darwin/`, `modules/linux/`, `modules/nixos/`: platform-specific modules
- `checks/`: flake checks and NixOS VM smoke test
- `programs/`: Neovim, zsh, and other user program config
- `services/`: Darwin service modules like `yabai` and `skhd`
- `other-dependencies/`: legacy area for externally sourced tools; prefer package-first wiring in `modules/shared/packages/`
- `scripts/`: rebuild, update, and inspection helpers

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
- Keep module arguments minimal and explicit, e.g. `{ pkgs, user, ... }:`.
- Prefer small helper bindings in `let` blocks when expressions are reused.
- Prefer explicit imports over clever dynamic module generation.
- Keep `flake.nix` boring: wire outputs and helpers there, move real logic into modules.
- Prefer shared logic in `modules/shared/` and host entrypoints in `hosts/`.
- Pass cross-cutting values via `specialArgs` / `extraSpecialArgs`, not ad hoc globals.
- Use `pkgs.stdenv.hostPlatform.system` instead of deprecated `pkgs.system`.
- Use assertions for invariants that should fail evaluation early.

## Package / Module Conventions

- Shared packages live in `modules/shared/packages/`.
- Darwin-only packages live in `modules/darwin/packages.nix`.
- Shared Home Manager wiring lives in `modules/shared/home.nix`.
- Host files should stay thin and mostly compose modules.
- Avoid reintroducing the old generated-user matrix approach from the previous flake.
- `nixpkgs` is the default source of truth for packages.
- Use plain `pkgs.<name>` when the packaged version in `nixpkgs` is acceptable.
- If a package exists in `nixpkgs` but must be upgraded independently, create a separately managed package entry with its own flake input and expose one canonical package symbol for it.
- If a package is missing from `nixpkgs` or the nixpkgs recipe is unsuitable, define it as a local custom package, preferably one package per file.
- Flake inputs are source declarations, not install targets; do not reference `inputs.*` directly from install lists or unrelated modules.
- Each tool must have one canonical package symbol across the repo: either `pkgs.<name>` or a custom symbol, but not both.
- Do not mix raw `pkgs.<name>`, overridden variants, and custom package references for the same tool in different modules.
- Keep package selection separate from package definition: package files define how to build; shared package lists decide what gets installed.

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

- Nix modules: descriptive lowercase file names, often `default.nix`, `system.nix`, `home.nix`, `packages.nix`
- Flake outputs: explicit host-oriented names like `ianluo`, `ian-linux-dev`, `nixos-vm`
- Helpers: `mkPkgs`, `mkSpecialArgs`, `mkSystemPackages`
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
2. Prefer minimal structural changes that follow the current host/module split.
3. Validate the smallest affected target first.
4. Then run broader checks if the change touches shared wiring.
5. Summarize platform limitations honestly, especially for Linux builds on Darwin.
