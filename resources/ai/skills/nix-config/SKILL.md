---
name: nix-config
description: Use when working on Nix flakes, Home Manager modules, nix-darwin, nixos configurations, package wiring, or repo organization in this environment.
compatibility: Works across Codex, OpenCode, and Claude-compatible skill loaders.
metadata:
  audience: personal-dotfiles
  domain: nix
---

## What this skill is for

Use this skill for changes involving flake outputs, Home Manager modules, host wiring, package selection, and Nix configuration structure.

## Working rules

- Treat this repository as a configuration repo, not an application repo.
- Keep host entrypoints thin and move reusable logic into modules.
- Prefer one canonical package source per tool.
- Keep package definition separate from package selection.
- Validate the smallest affected target first, then broader flake checks when shared wiring changes.

## Validation expectations

- For flake wiring changes, run `nix flake check --all-systems`.
- For targeted checks, use focused `nix eval` or `nix build` first.
- On Darwin, do not assume full Linux-target builds are available locally unless evaluation is sufficient.

## Repository guidance

Read `references/repo-guidance.md` before making structural changes.
