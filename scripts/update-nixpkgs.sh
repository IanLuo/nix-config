#!/usr/bin/env bash

set -euo pipefail

echo "Updating the nixpkgs input (nixpkgs-unstable)..."
nix flake lock --update-input nixpkgs

echo "Update complete. Run './scripts/rebuild.sh' to apply changes."
