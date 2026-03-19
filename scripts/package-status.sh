#!/usr/bin/env bash

set -euo pipefail

metadata_json="$(nix flake metadata --json)"

echo "Package Management Status"
echo "=============================="

echo
echo "Current Inputs:"
echo "  nixpkgs:        $(jq -r '.locks.nodes.nixpkgs.locked.rev[0:7]' <<<"$metadata_json")"
echo "  nixpkgs-stable: $(jq -r '.locks.nodes."nixpkgs-stable".locked.rev[0:7]' <<<"$metadata_json")"
echo
echo "Note: current flake wiring uses 'nixpkgs' for both stable and unstable package groups."

echo
echo "Update Options:"
echo "  ./scripts/update-stable.sh    - Update the current nixpkgs input"
echo "  ./scripts/update-unstable.sh  - Same as above until a distinct unstable input is wired"
echo "  ./scripts/update-all.sh       - Update everything"
echo "  ./scripts/rebuild.sh          - Apply current configuration"
echo "  ./scripts/bleeding-edge.sh    - Manage bleeding-edge packages"

echo
echo "Package Categories:"
echo "  Stable:   Core system tools (git, gcc, shell, etc.)"
echo "  Unstable: Development tools (nixd, ripgrep, fd, etc.)"

echo
echo "Tips:"
echo "  - Check 'nix flake check --all-systems' before rebuilding"
echo "  - Use './scripts/rebuild.sh' after input updates"
