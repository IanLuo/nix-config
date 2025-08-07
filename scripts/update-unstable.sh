#!/usr/bin/env bash

# Update only unstable nixpkgs  
echo "🔄 Updating unstable nixpkgs (development tools)..."
nix flake lock --update-input nixpkgs-unstable

echo "✅ Updated development packages. Run './scripts/rebuild.sh' to apply changes."
