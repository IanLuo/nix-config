#!/usr/bin/env bash

echo "📦 Package Management Status"
echo "=============================="

# Show current nixpkgs versions
echo ""
echo "📌 Current Versions:"
echo "  Stable nixpkgs:   $(nix flake metadata --json | jq -r '.locks.nodes.nixpkgs.locked.rev[0:7]')"
echo "  Unstable nixpkgs: $(nix flake metadata --json | jq -r '.locks.nodes."nixpkgs-unstable".locked.rev[0:7]')"

echo ""
echo "🔄 Update Options:"
echo "  ./scripts/update-stable.sh    - Update stable packages only"
echo "  ./scripts/update-unstable.sh  - Update development tools only"
echo "  ./scripts/update-all.sh       - Update everything"
echo "  ./scripts/rebuild.sh          - Apply current configuration"
echo "  ./scripts/bleeding-edge.sh    - Manage bleeding-edge packages"

echo ""
echo "📋 Package Categories:"
echo "  Stable:   Core system tools (git, gcc, shell, etc.)"
echo "  Unstable: Development tools (nodejs, nixd, ripgrep, etc.)"

echo ""
echo "💡 Pro Tips:"
echo "  - Use update-unstable.sh for latest development tools"
echo "  - Use update-stable.sh for system-wide updates"
echo "  - Check 'nix flake check' before rebuilding"
