{ pkgs, lib, customPackages, ... }:
# General CLI apps moved to the Brewfile (repo root). Only nix-integrated
# tooling stays here.
with pkgs;
[
  # nix-ecosystem tooling (must stay in nix)
  nix-direnv
  any-nix-shell
  manix
  nix-prefetch-git
]
# ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
