{ pkgs, lib, ... }:
with pkgs;
[
  git
  gcc
  curl
  wget
  tree
  zsh
  direnv
  nix-direnv
  any-nix-shell
  tmate
  manix
  nix-prefetch-git
  uv

  (writeShellScriptBin "agy" ''
    APP_PATH="/Applications/Antigravity.app"
    CLI_DIR="$APP_PATH/Contents/Resources/app/bin"

    if [ -d "$CLI_DIR" ]; then
      if [ -x "$CLI_DIR/antigravity" ]; then
        exec "$CLI_DIR/antigravity" "$@"
      elif [ -x "$CLI_DIR/code" ]; then
        exec "$CLI_DIR/code" "$@"
      else
        SCRIPT=$(find "$CLI_DIR" -maxdepth 1 -type f -perm +111 | head -n 1)
        if [ -n "$SCRIPT" ]; then
          exec "$SCRIPT" "$@"
        fi
      fi
    fi

    if [ -f "$APP_PATH/Contents/MacOS/Antigravity" ]; then
      echo "Warning: Using direct binary execution. Authentication might fail." >&2
      exec "$APP_PATH/Contents/MacOS/Antigravity" "$@"
    else
      echo "Error: Could not find Antigravity app or CLI script." >&2
      exit 1
    fi
  '')
]
++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
