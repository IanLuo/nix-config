#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
FLAKE_DIR="$(dirname "$SCRIPT_DIR")"
cd "$FLAKE_DIR"

export PATH="/nix/var/nix/profiles/default/bin:$PATH"

echo "Applying Nix configuration..."

apply_nix_conf() {
  # macOS nix daemon settings (from ./nix.conf). Needs sudo; non-fatal if skipped.
  if [ -f "$FLAKE_DIR/nix.conf" ]; then
    if sudo -n mkdir -p /etc/nix 2>/dev/null && sudo -n cp "$FLAKE_DIR/nix.conf" /etc/nix/nix.conf 2>/dev/null; then
      echo "nix.conf applied to /etc/nix/nix.conf"
    else
      echo "nix.conf: skipped (needs sudo). Apply manually:"
      echo "  sudo cp nix.conf /etc/nix/nix.conf"
    fi
  fi
}

apply_brew() {
  # Apps layer (pi, claude-code, herdr, aerospace, CLI tools)
  if command -v brew >/dev/null 2>&1; then
    brew bundle --file "$FLAKE_DIR/Brewfile"
  else
    echo "Homebrew not installed. Install first:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  fi
}

switch_home() {
  local target="$1"
  if command -v home-manager >/dev/null 2>&1; then
    home-manager switch --flake ".#$target"
  else
    echo "home-manager not on PATH; running via nix run..."
    nix run github:nix-community/home-manager -- switch --flake ".#$target"
  fi
}

if [ -e /etc/NIXOS ]; then
  TARGET="${NIXOS_CONFIG_NAME:-nixos-vm}"
  echo "Detected NixOS. Switching to target: $TARGET"
  sudo nixos-rebuild switch --flake ".#$TARGET"

elif [ "$(uname)" = "Darwin" ]; then
  TARGET="${HOME_CONFIG_NAME:-ianluo}"
  echo "Detected macOS. Switching Home Manager target: $TARGET"

  apply_nix_conf
  switch_home "$TARGET"
  apply_brew

else
  TARGET="${HOME_CONFIG_NAME:-ian-linux-dev}"
  echo "Detected Linux. Switching Home Manager target: $TARGET"
  switch_home "$TARGET"
fi

echo "Configuration applied successfully."
