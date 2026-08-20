# My Nix-based Dotfiles

A declarative personal environment for macOS, standalone Linux Home Manager, and NixOS, managed with a dendritic flake structure.

## Key Features

- Cross-platform: standalone Home Manager on macOS and Linux, plus NixOS
- Feature-centric: Nix modules are organized by aspect, not by platform directory
- Auto-loaded: `flake-parts` and `import-tree` load the aspect tree from `modules/`
- Verified: `nix flake check --all-systems` covers config invariants and a NixOS VM smoke test

## Structure

```text
.
├── flake.nix
├── modules/
│   ├── hosts/
│   ├── repo.nix
│   ├── home-base.nix
│   ├── system-packages.nix
│   ├── cli.nix
│   ├── shell.nix
│   ├── editor.nix
│   ├── system-foundation.nix
│   ├── window-management.nix
│   ├── remote-access.nix
│   └── checks.nix
├── packages/
├── nixos/
├── programs/
├── services/
└── scripts/
```

`modules/` contains the flake-parts module tree. Each file defines one aspect and can contribute modules to `nixos` or `homeManager` through `flake.modules.<class>.<aspect>`.

## Flake Outputs

- `homeConfigurations.ianluo`
- `homeConfigurations.ian-linux-dev`
- `nixosConfigurations.nixos-vm`

## Installation And Apply

- macOS: `./scripts/setup.sh` (home-manager switch)
- standalone Linux Home Manager: `HOME_CONFIG_NAME=ian-linux-dev ./scripts/setup.sh`
- NixOS: `sudo NIXOS_CONFIG_NAME=nixos-vm ./scripts/setup.sh`

There are also compatibility wrappers:

- `./scripts/rebuild.sh`

## Update Workflow

- `./scripts/update-all.sh` updates all flake inputs
- `./scripts/update-nixpkgs.sh` updates the `nixpkgs` (unstable) input
- `./scripts/store.sh` manages the nix store (status/gc/optimise/disk-usage)
- `./scripts/update-stable.sh` updates the `nixpkgs-stable` (25.05) input
- `./scripts/update-nixpkgs.sh` updates the `nixpkgs` (unstable) input

## Validation

Run:

```bash
nix flake check --all-systems
```

That evaluates all outputs, runs invariant checks, and evaluates the NixOS VM smoke test derivation.
