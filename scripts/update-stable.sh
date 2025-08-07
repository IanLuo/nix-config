#!/usr/bin/env bash

# Update only stable nixpkgs
echo "🔄 Updating stable nixpkgs..."
nix flake lock --update-input nixpkgs

echo "✅ Updated stable packages. Run './scripts/rebuild.sh' to apply changes."
