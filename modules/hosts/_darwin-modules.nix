{ config }:
# Shared module list for all macOS (darwin) hosts.
# Each host file calls this and appends its own inline config block.
with config.flake.modules.homeManager; [
  base
  stable-packages
  unstable-packages
  llm-agents-packages
  herdr
  cli
  shell
  tmux
  editor
  aerospace
  sketchybar
  kitty
  ghostty
  alacritty
  nix-gc
  macos-defaults
]
