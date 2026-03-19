#!/usr/bin/env bash

set -euo pipefail

echo "Updating all flake inputs..."

nix flake update

echo "Update complete. Run './scripts/rebuild.sh' to apply changes."

echo
echo "Recent changes:"
if ! git diff --quiet -- flake.lock; then
  echo "  flake.lock has been updated"
  echo
  echo "See details with: git diff flake.lock"
fi
