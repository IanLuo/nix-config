# Package Update Guide

## Current State

The repo now has separate package groups in code, but the current flake wiring still sources both the "stable" and "unstable" groups from the same `nixpkgs` input.

That means:

- package organization is separated in `modules/shared/packages/stable.nix` and `modules/shared/packages/unstable.nix`
- update intent is separated in scripts
- actual input updates are not yet separated by source branch

## Package Layout

- `modules/shared/packages/stable.nix` for core tools
- `modules/shared/packages/unstable.nix` for faster-moving dev tools
- `modules/darwin/packages.nix` for Darwin-only packages
- `programs/bleeding-edge/` for custom packages built outside the normal package flow

## Current Update Commands

### Apply Configuration

```bash
./scripts/rebuild.sh
```

### Update Current Nixpkgs Input

```bash
./scripts/update-stable.sh
./scripts/rebuild.sh
```

### Update Everything

```bash
./scripts/update-all.sh
./scripts/rebuild.sh
```

### Check Status

```bash
./scripts/package-status.sh
```

## Important Note About `update-unstable.sh`

`./scripts/update-unstable.sh` currently updates the same `nixpkgs` input as `./scripts/update-stable.sh`.

It exists as a workflow placeholder and convenience alias, but it does not currently target a distinct `nixpkgs-unstable` input in the active flake wiring.

## Validation

Before rebuilding, run:

```bash
nix flake check --all-systems
```

For a local Darwin build smoke test:

```bash
nix build .#darwinConfigurations.ianluo.config.system.build.toplevel
```

## If You Want True Split Update Cadence Later

To make `update-stable.sh` and `update-unstable.sh` truly independent, the next step would be to wire distinct flake inputs into `mkPkgs` and `mkUnstablePkgs` in `flake.nix`.
