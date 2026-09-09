#!/usr/bin/env bash
set -uo pipefail

SB="$(command -v sketchybar || true)"
[ -n "$SB" ] || SB="$HOME/.nix-profile/bin/sketchybar"

APP="$(printenv INFO || true)"

"$SB" --set front_app icon="" label="[ $APP ]"
