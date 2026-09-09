#!/usr/bin/env bash
# Wi-Fi indicator. Check if the Wi-Fi interface has an IP address —
# works even when the default route goes through a VPN tunnel.
set -uo pipefail

SB="$(command -v sketchybar || true)"
[ -n "$SB" ] || SB="$HOME/.nix-profile/bin/sketchybar"

WIFI_DEV="$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2}')"
[ -n "$WIFI_DEV" ] || WIFI_DEV="en0"

ICON="$(printf '\xef\x87\xab')"   # nerd-font wifi glyph U+F1EB
if ipconfig getifaddr "$WIFI_DEV" >/dev/null 2>&1; then
  "$SB" --set wifi icon="$ICON" icon.color=0xffffffff   # white: connected
else
  "$SB" --set wifi icon="$ICON" icon.color=0xff3f4b60   # dim: no wifi
fi
