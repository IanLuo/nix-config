#!/usr/bin/env bash

set -euo pipefail

echo "Updating the nixpkgs-stable input (25.05 branch)..."
nix flake lock --update-input nixpkgs-stable

echo "Update complete. Run './scripts/rebuild.sh' to apply changes."
