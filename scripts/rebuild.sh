#!/usr/bin/env bash

# Detect system and rebuild appropriately
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Rebuilding macOS configuration..."
    darwin-rebuild switch --flake ~/.config/darwin
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Rebuilding Linux configuration..."
    if command -v nixos-rebuild &> /dev/null; then
        # NixOS system
        sudo nixos-rebuild switch --flake ~/.config/darwin
    else
        # Home Manager only
        home-manager switch --flake ~/.config/darwin
    fi
else
    echo "❌ Unsupported system type: $OSTYPE"
    exit 1
fi

echo "✅ System rebuilt successfully!"
