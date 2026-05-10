#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
FLAKE_DIR="$(dirname "$SCRIPT_DIR")"
cd "$FLAKE_DIR"

export PATH="/nix/var/nix/profiles/default/bin:$PATH"

echo "Applying Nix configuration..."

if [ -e /etc/NIXOS ]; then
  TARGET="${NIXOS_CONFIG_NAME:-nixos-vm}"
  echo "Detected NixOS. Switching to target: $TARGET"
  sudo nixos-rebuild switch --flake ".#$TARGET"

elif [ "$(uname)" = "Darwin" ]; then
  TARGET="${DARWIN_CONFIG_NAME:-ianluo}"
  echo "Detected macOS. Switching to target: $TARGET"

  if command -v darwin-rebuild >/dev/null 2>&1; then
    darwin-rebuild switch --flake ".#$TARGET"
  else
    echo "darwin-rebuild not found. Bootstrapping via nix run nix-darwin..."
    nix run nix-darwin -- switch --flake ".#$TARGET"
  fi

else
  TARGET="${HOME_CONFIG_NAME:-ian-linux-dev}"
  echo "Detected Linux. Switching Home Manager target: $TARGET"
  home-manager switch --flake ".#$TARGET"
fi

echo "Configuration applied successfully."
