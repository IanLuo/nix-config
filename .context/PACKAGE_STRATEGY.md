# Package Strategy

## Current Package Organization

The package layout is now organized by module, not by one large `systemPackages.nix` file.

- `modules/shared/packages/stable.nix`
- `modules/shared/packages/unstable.nix`
- `modules/shared/packages/default.nix`
- `modules/darwin/packages.nix`
- `programs/bleeding-edge/default.nix`

## Intent

- keep core tools in the shared stable group
- keep faster-moving development tools in the shared unstable group
- keep Darwin-only packages in a dedicated Darwin module
- use bleeding-edge packages only when nixpkgs is not enough

## Important Constraint

Although the package groups are split logically, both shared groups are currently sourced from the active `nixpkgs` import in `flake.nix`.

So today this is mainly:

- organizational separation
- documentation of update intent
- easier future migration to truly distinct inputs

It is not yet a full dual-channel package strategy in practice.

## What To Change For A True Dual-Input Strategy

If you want real split update cadence later:

1. wire `mkPkgs` to one input
2. wire `mkUnstablePkgs` to another input
3. keep `modules/shared/packages/stable.nix` and `modules/shared/packages/unstable.nix` as they are
4. keep the scripts as the user-facing workflow

## Build Targets To Use

- Darwin build: `nix build .#darwinConfigurations.ianluo.config.system.build.toplevel`
- Linux HM eval/build target: `nix build .#homeConfigurations.ian-linux-dev.activationPackage`
- NixOS eval/build target: `nix build .#nixosConfigurations.nixos-vm.config.system.build.toplevel`
