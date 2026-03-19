#!/usr/bin/env bash

set -euo pipefail

echo "Updating the nixpkgs input used by the current package set..."
nix flake lock --update-input nixpkgs

echo "Note: the current flake wiring uses 'nixpkgs' for both stable and unstable package groups."
echo "Update complete. Run './scripts/rebuild.sh' to apply changes."
