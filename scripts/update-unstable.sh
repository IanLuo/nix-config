#!/usr/bin/env bash

set -euo pipefail

echo "Updating the nixpkgs input used by development tools..."
nix flake lock --update-input nixpkgs

echo "Note: the current flake does not wire a separate nixpkgs-unstable input into packages."
echo "Update complete. Run './scripts/rebuild.sh' to apply changes."
