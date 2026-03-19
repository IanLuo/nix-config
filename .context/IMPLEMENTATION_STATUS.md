# Implementation Status

## Completed

### Flake And Module Refactor
- explicit flake outputs for Darwin, NixOS, and standalone Home Manager
- host entrypoints under `hosts/`
- shared and platform modules under `modules/`
- package composition moved to `modules/shared/packages/`

### Validation
- `nix flake check --all-systems`
- Darwin build evaluation and local build
- flake checks for config invariants
- NixOS VM smoke test derivation in `checks/default.nix`

### Scripts
- `scripts/setup.sh` now resolves the correct flake target more safely
- `scripts/rebuild.sh` added as the main compatibility wrapper
- update scripts now reflect current flake wiring
- dependency-check script no longer depends on a generated temp Nix file

## Current Reality

- `nixpkgs-stable` exists as a flake input
- the active package wiring currently still builds both grouped package sets from `nixpkgs`
- so the update scripts are now honest about that instead of pretending there is already a fully split stable/unstable input flow

## Primary Outputs

- `darwinConfigurations.ianluo`
- `homeConfigurations.ian-linux-dev`
- `nixosConfigurations.nixos-vm`

## Recommended Workflow

```bash
nix flake check --all-systems
./scripts/rebuild.sh
```

For updates:

```bash
./scripts/update-all.sh
./scripts/rebuild.sh
```

## Possible Follow-up

If you want truly independent stable and unstable updates, the next follow-up is to change `flake.nix` so `mkPkgs` and `mkUnstablePkgs` use different inputs in practice, not just different package group files.
