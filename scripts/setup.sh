#!/usr/bin/env bash

set -e

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
FLAKE_DIR="$(dirname "$SCRIPT_DIR")"

# Change to the flake directory
cd "$FLAKE_DIR"

# Determine the actual user running the script
# If run with sudo, SUDO_USER will contain the original user's name
# Otherwise, use the current user
ACTUAL_USER="${SUDO_USER:-$(whoami)}"

echo "Applying Nix configuration for user: $ACTUAL_USER..."

if [ -e /etc/NIXOS ]; then
  echo "Detected NixOS. Building and switching..."
  sudo nixos-rebuild switch --flake .#$ACTUAL_USER # Use actual user for NixOS
elif [ "$(uname)" == "Darwin" ]; then
  echo "Detected macOS. Building and switching..."
  darwin-rebuild switch --flake .#$ACTUAL_USER # Use actual user for Darwin

else
  echo "Detected non-NixOS Linux. Building and switching Home Manager..."
  home-manager switch --flake .#$ACTUAL_USER # Use actual user for Home Manager
fi

echo "✅ Configuration applied successfully."
