{ config }:
# Shared module list for all macOS (darwin) hosts.
# Each host file calls this and appends its own inline config block.
with config.flake.modules.homeManager; [
  base
  stable-packages
  unstable-packages
  llm-agents-packages
  pi-harness
  herdr
  cli
  shell
  editor
  aerospace
  sketchybar
  kitty
  ghostty
  alacritty
  nix-gc
  macos-defaults
]
