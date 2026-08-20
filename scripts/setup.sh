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
    echo "Homebrew not found — installing (one-time, may prompt for sudo)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
    brew bundle --file "$FLAKE_DIR/Brewfile"
  fi
}

switch_home() {
  local target="$1"
  if command -v home-manager >/dev/null 2>&1; then
    home-manager switch --flake ".#$target"
  else
    # Install the home-manager CLI from the flake's PINNED input (no network
    # fetch — avoids github TLS flakiness and version drift vs master).
    local hm_src
    hm_src="$(nix flake archive --json 2>/dev/null | python3 -c 'import json,sys; print(json.load(sys.stdin)["inputs"]["home-manager"]["path"])' 2>/dev/null || true)"
    if [ -n "$hm_src" ]; then
      echo "Installing pinned home-manager CLI ($hm_src)..."
      nix profile install "$hm_src#home-manager"
      home-manager switch --flake ".#$target"
    else
      echo "home-manager unavailable. Install it manually:"
      echo "  nix profile install github:nix-community/home-manager"
      return 1
    fi
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
