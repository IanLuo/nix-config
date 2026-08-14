{ unstable-pkgs, ... }:
# General CLI apps moved to the Brewfile (repo root). Only nix-integrated
# tooling stays here.
with unstable-pkgs;
[
  # nix-ecosystem tooling (must stay in nix)
  nixd
  nix-index
  nix-tree
  nix-du
]
