#!/usr/bin/env bash
# Wi-Fi indicator. macOS 26's networksetup misreports association, so detect
# by whether the default route goes through the Wi-Fi device.
set -uo pipefail

SB="$(command -v sketchybar || true)"
[ -n "$SB" ] || SB="$HOME/.nix-profile/bin/sketchybar"

WIFI_DEV="$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2}')"
[ -n "$WIFI_DEV" ] || WIFI_DEV="en0"
DEF_IF="$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')"

ICON="$(printf '')"   # nerd-font wifi glyph
if [ -n "$DEF_IF" ] && [ "$DEF_IF" = "$WIFI_DEV" ]; then
  "$SB" --set wifi icon="$ICON" icon.color=0xffffffff   # white: connected
else
  "$SB" --set wifi icon="$ICON" icon.color=0xff3f4b60   # dim: no wifi
fi
