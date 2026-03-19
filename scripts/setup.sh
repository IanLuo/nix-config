#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
FLAKE_DIR="$(dirname "$SCRIPT_DIR")"

cd "$FLAKE_DIR"

ACTUAL_USER="${SUDO_USER:-$(id -un)}"
ACTUAL_GROUP="$(id -gn "$ACTUAL_USER")"
CURRENT_HOST="$(hostname -s 2>/dev/null || hostname)"

resolve_home_dir() {
  if command -v dscl >/dev/null 2>&1; then
    dscl . -read "/Users/$ACTUAL_USER" NFSHomeDirectory | cut -d' ' -f2-
  elif command -v getent >/dev/null 2>&1; then
    getent passwd "$ACTUAL_USER" | cut -d: -f6
  else
    printf '%s\n' "$HOME"
  fi
}

resolve_config_name() {
  local output_attr="$1"
  local override="$2"
  shift 2

  if [ -n "$override" ]; then
    printf '%s\n' "$override"
    return 0
  fi

  local names_raw
  names_raw="$(nix eval --raw ".#$output_attr" --apply 'attrs: builtins.concatStringsSep "\n" (builtins.attrNames attrs)')"

  for candidate in "$@"; do
    if [ -n "$candidate" ] && printf '%s\n' "$names_raw" | while IFS= read -r name; do [ "$name" = "$candidate" ] && exit 0; done; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  if [ "$(printf '%s\n' "$names_raw" | sed '/^$/d' | wc -l | tr -d ' ')" -eq 1 ]; then
    printf '%s\n' "$names_raw"
    return 0
  fi

  echo "Could not determine target in $output_attr. Set an override environment variable." >&2
  return 1
}

ACTUAL_HOME="$(resolve_home_dir)"

echo "Applying Nix configuration for user: $ACTUAL_USER..."
echo "User home directory: $ACTUAL_HOME"

if [ -n "${SUDO_USER:-}" ]; then
  echo "Fixing UV and npm directory permissions..."
  mkdir -p "$ACTUAL_HOME/.cache/uv"
  mkdir -p "$ACTUAL_HOME/.local/share/uv"
  mkdir -p "$ACTUAL_HOME/.npm-global"

  chown -R "$ACTUAL_USER:$ACTUAL_GROUP" "$ACTUAL_HOME/.cache/uv" 2>/dev/null || true
  chown -R "$ACTUAL_USER:$ACTUAL_GROUP" "$ACTUAL_HOME/.local" 2>/dev/null || true
  chown -R "$ACTUAL_USER:$ACTUAL_GROUP" "$ACTUAL_HOME/.npm-global" 2>/dev/null || true
fi

if [ -e /etc/NIXOS ]; then
  TARGET="$(resolve_config_name nixosConfigurations "${NIXOS_CONFIG_NAME:-}" "$CURRENT_HOST" "$ACTUAL_USER")"
  echo "Detected NixOS. Building and switching target: $TARGET"
  sudo nixos-rebuild switch --flake ".#$TARGET"
elif [ "$(uname)" = "Darwin" ]; then
  TARGET="$(resolve_config_name darwinConfigurations "${DARWIN_CONFIG_NAME:-}" "$ACTUAL_USER" "$CURRENT_HOST")"
  echo "Detected macOS. Building and switching target: $TARGET"

  if command -v darwin-rebuild >/dev/null 2>&1; then
    echo "Using darwin-rebuild..."
    darwin-rebuild switch --flake ".#$TARGET"
  else
    echo "darwin-rebuild not found. Using nix run nix-darwin for initial setup..."
    nix run nix-darwin -- switch --flake ".#$TARGET"
  fi

  echo "Installing global dependencies as user $ACTUAL_USER..."
  if [ -n "${SUDO_USER:-}" ]; then
    sudo -H -u "$ACTUAL_USER" bash -lc '
      export PATH="$HOME/.local/bin:$PATH"
      export UV_CACHE_DIR="$HOME/.cache/uv"
      echo "Installing Python global tools..."
      echo "Installing Node.js global tools..."
      if [ -f "$HOME/.npm-global/package.json" ]; then
        npm install --prefix "$HOME/.npm-global" || echo "npm install failed"
      fi
    '
  else
    export UV_CACHE_DIR="$HOME/.cache/uv"
    echo "Installing Python global tools..."
    echo "Installing Node.js global tools..."
    if [ -f "$HOME/.npm-global/package.json" ]; then
      npm install --prefix "$HOME/.npm-global" || echo "npm install failed"
    fi
  fi
else
  TARGET="$(resolve_config_name homeConfigurations "${HOME_CONFIG_NAME:-}" "$ACTUAL_USER" "$CURRENT_HOST")"
  echo "Detected non-NixOS Linux. Building and switching Home Manager target: $TARGET"
  home-manager switch --flake ".#$TARGET"
fi

echo "✅ Configuration applied successfully."
