#!/usr/bin/env bash

set -euo pipefail

echo "Updating the nixpkgs input (25.05 stable branch)..."
nix flake lock --update-input nixpkgs

echo "Update complete. Run './scripts/rebuild.sh' to apply changes."
