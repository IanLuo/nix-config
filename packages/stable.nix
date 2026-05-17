{ pkgs, lib, customPackages, ... }:
with pkgs;
[
  gcc
  curl
  wget
  tree
  direnv
  nix-direnv
  any-nix-shell
  manix
  nix-prefetch-git
  uv
  bun
  graphviz
]
# ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
