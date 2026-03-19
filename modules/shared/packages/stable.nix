{ pkgs, lib, ... }:
with pkgs;
[
  git
  gcc
  curl
  wget
  tree
  zsh
  direnv
  nix-direnv
  any-nix-shell
  tmate
  manix
  nix-prefetch-git
  uv
]
# ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
