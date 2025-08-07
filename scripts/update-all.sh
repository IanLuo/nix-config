#!/usr/bin/env bash

echo "🔄 Updating all flake inputs..."

# Update all inputs
nix flake update

echo "✅ All inputs updated. Run './scripts/rebuild.sh' to apply changes."

# Show what changed
echo ""
echo "📋 Recent changes:"
git diff --name-only flake.lock | head -1 > /dev/null && {
    echo "  flake.lock has been updated"
    echo ""
    echo "💡 You can see the changes with: git diff flake.lock"
}
