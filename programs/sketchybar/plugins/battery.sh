#!/usr/bin/env bash
set -uo pipefail

SB="$(command -v sketchybar || true)"
[ -n "$SB" ] || SB="$HOME/.nix-profile/bin/sketchybar"

PCT="$(pmset -g batt 2>/dev/null | grep -oE '[0-9]+%' | head -1 | tr -d '%')"
STATE="$(pmset -g batt 2>/dev/null | grep -oE 'AC Power|Battery Power' | head -1)"
[ -n "$PCT" ] || PCT=100

if [ "$PCT" -gt 50 ]; then COLOR="0xffffffff"   # white while healthy
elif [ "$PCT" -ge 20 ]; then COLOR="0xffd19a66" # nightfox orange
else COLOR="0xffc94f6d"; fi                      # nightfox red

"$SB" --set battery label="$PCT%" label.color="$COLOR"
