#!/usr/bin/env bash
set -uo pipefail

SB="$(command -v sketchybar || true)"
[ -n "$SB" ] || SB="$HOME/.nix-profile/bin/sketchybar"

APP="$(printenv INFO || true)"

case "$APP" in
  Finder)                          GLYPH="$(printf '')" ;;
  Safari|"Google Chrome"|Arc|Brave|Firefox) GLYPH="$(printf '')" ;;
  kitty|herdr|Alacritty|Terminal|WezTerm|iTerm2) GLYPH="$(printf '')" ;;
  "Visual Studio Code"|*[Cc]ode*|Cursor) GLYPH="$(printf '')" ;;
  *)                               GLYPH="$(printf '')" ;;
esac

"$SB" --set front_app icon="$GLYPH" label="$APP"
