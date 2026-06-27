# My Nix-based Dotfiles

A declarative personal environment for macOS, standalone Linux Home Manager, and NixOS, managed with a dendritic flake structure.

## Key Features

- Cross-platform: supports `nix-darwin`, standalone Home Manager on Linux, and NixOS
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

`modules/` contains the flake-parts module tree. Each file defines one aspect and can contribute modules to `nixos`, `darwin`, or `homeManager` through `flake.modules.<class>.<aspect>`.

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
- `./scripts/update-stable.sh` updates `nixpkgs-stable`
- `./scripts/update-unstable.sh` updates `nixpkgs`
- `./scripts/package-status.sh` shows the current locked inputs and package grouping
- `./scripts/bleeding-edge.sh` helps manage custom bleeding-edge packages
- Custom package sources are pinned as dedicated flake inputs, so they can be updated independently with `nix flake lock --update-input <input-name>`

## Validation

Run:

```bash
nix flake check --all-systems
```

That evaluates all outputs, runs invariant checks, and evaluates the NixOS VM smoke test derivation.
