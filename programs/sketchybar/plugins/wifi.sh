#!/usr/bin/env bash
set -uo pipefail

SB="$(command -v sketchybar || true)"
[ -n "$SB" ] || SB="$HOME/.nix-profile/bin/sketchybar"

ICON="$(printf '')"   # nerd-font wifi glyph (emitted via printf
                            # so the codepoint survives nix encoding)
SSID="$(networksetup -getairportnetwork en0 2>/dev/null | sed -n 's/^Current Wi-Fi Network: //p')"
if [ -n "$SSID" ]; then
  "$SB" --set wifi icon="$ICON" icon.color=0xff63cdcf label=" $SSID" label.color=0xffcdcecf
else
  "$SB" --set wifi icon="$ICON" icon.color=0xff7f8c98 label=""
fi
