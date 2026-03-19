# My Nix-based Dotfiles

A declarative personal environment for macOS, standalone Linux Home Manager, and NixOS, managed with Nix flakes.

## Key Features

- Cross-platform: supports `nix-darwin`, standalone Home Manager on Linux, and NixOS
- Declarative: system and user configuration live in versioned Nix modules
- Modular: host entrypoints, shared modules, and platform-specific modules are separated cleanly
- Verified: `nix flake check --all-systems` covers config invariants and a NixOS VM smoke test

## Structure

```
.
├── flake.nix
├── hosts/
│   ├── darwin/
│   ├── home/
│   └── nixos/
├── modules/
│   ├── darwin/
│   ├── linux/
│   ├── nixos/
│   └── shared/
├── nixos/
├── programs/
├── services/
├── checks/
└── scripts/
```

## Flake Outputs

- `darwinConfigurations.ianluo`
- `homeConfigurations.ian-linux-dev`
- `nixosConfigurations.nixos-vm`

## Installation And Apply

- macOS: `./scripts/setup.sh` or `DARWIN_CONFIG_NAME=ianluo ./scripts/setup.sh`
- standalone Linux Home Manager: `HOME_CONFIG_NAME=ian-linux-dev ./scripts/setup.sh`
- NixOS: `sudo NIXOS_CONFIG_NAME=nixos-vm ./scripts/setup.sh`

There are also compatibility wrappers:

- `./scripts/rebuild.sh`
- `./ianluo.switch.sh`
- `./ian.linux.switch.sh`
- `./install.sh`

## Update Workflow

- `./scripts/update-all.sh` updates all flake inputs
- `./scripts/update-stable.sh` updates the currently wired `nixpkgs` input
- `./scripts/update-unstable.sh` currently does the same, because package groups are both sourced from `nixpkgs` in the current flake wiring
- `./scripts/package-status.sh` shows the current locked inputs and reminds you about the current package wiring
- `./scripts/bleeding-edge.sh` helps manage custom bleeding-edge packages
- `./scripts/check-other-dependencies.sh` checks configured external Python/npm tools for newer upstream versions

## Validation

Run:

```bash
nix flake check --all-systems
```

That evaluates all outputs, runs invariant checks, and evaluates the NixOS VM smoke test derivation.
