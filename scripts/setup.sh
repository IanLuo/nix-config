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
ACTUAL_HOME=$(eval echo "~$ACTUAL_USER")

echo "Applying Nix configuration for user: $ACTUAL_USER..."
echo "User home directory: $ACTUAL_HOME"

# Fix UV and npm directory permissions if running with sudo
if [ -n "$SUDO_USER" ]; then
  echo "Fixing UV and npm directory permissions..."
  # Create directories if they don't exist and fix ownership
  mkdir -p "$ACTUAL_HOME/.cache/uv"
  mkdir -p "$ACTUAL_HOME/.local/share/uv" 
  mkdir -p "$ACTUAL_HOME/.npm-global"
  
  # Fix ownership
  chown -R "$SUDO_USER:staff" "$ACTUAL_HOME/.cache/uv" 2>/dev/null || true
  chown -R "$SUDO_USER:staff" "$ACTUAL_HOME/.local" 2>/dev/null || true
  chown -R "$SUDO_USER:staff" "$ACTUAL_HOME/.npm-global" 2>/dev/null || true
fi

if [ -e /etc/NIXOS ]; then
  echo "Detected NixOS. Building and switching..."
  sudo nixos-rebuild switch --flake .#$ACTUAL_USER # Use actual user for NixOS
elif [ "$(uname)" == "Darwin" ]; then
  echo "Detected macOS. Building and switching..."
  darwin-rebuild switch --flake .#$ACTUAL_USER # Use actual user for Darwin
  
  # Post-build: Install global dependencies as the actual user
  echo "Installing global dependencies as user $ACTUAL_USER..."
  if [ -n "$SUDO_USER" ]; then
    # Run as the actual user, not root
    sudo -u "$SUDO_USER" bash -c "
      export PATH=\"$HOME/.local/bin:$PATH\"
      export UV_CACHE_DIR=\"$HOME/.cache/uv\"
      echo 'Installing Python global tools...'
      uv tool install speckit || echo 'UV install failed'
      echo 'Installing Node.js global tools...'
      if [ -f \"$HOME/.npm-global/package.json\" ]; then
        cd \"$HOME/.npm-global\" && npm install || echo 'npm install failed'
      fi
    "
  else
    # Running without sudo, install normally
    export UV_CACHE_DIR="$HOME/.cache/uv"
    echo 'Installing Python global tools...'
    uv tool install speckit || echo 'UV install failed'
    echo 'Installing Node.js global tools...'
    if [ -f "$HOME/.npm-global/package.json" ]; then
      cd "$HOME/.npm-global" && npm install || echo 'npm install failed'
    fi
  fi

else
  echo "Detected non-NixOS Linux. Building and switching Home Manager..."
  home-manager switch --flake .#$ACTUAL_USER # Use actual user for Home Manager
fi

echo "✅ Configuration applied successfully."
