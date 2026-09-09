#!/usr/bin/env bash
# Badge-count indicator for messaging apps. Polls via lsappinfo and
# shows a colored dot + count when badges > 0, hides when 0.
# Called by sketchybar with $NAME set to the item name (badge.teams, etc).
set -uo pipefail

SB="$(command -v sketchybar || true)"
[ -n "$SB" ] || SB="$HOME/.nix-profile/bin/sketchybar"

NAME="${NAME:-}"
[ -n "$NAME" ] || exit 0

# Map item name → bundle ID + accent color
case "$NAME" in
  badge.teams)   BUNDLE="com.microsoft.teams2"       COLOR="0xff7b83eb" ;;
  badge.outlook) BUNDLE="com.microsoft.Outlook"       COLOR="0xff0078d4" ;;
  badge.slack)   BUNDLE="com.tinyspeck.slackmacgap"   COLOR="0xff4a154b" ;;
  badge.messages) BUNDLE="com.apple.MobileSMS"        COLOR="0xff34c759" ;;
  *) exit 0 ;;
esac

# lsappinfo prints StatusLabel info; extract the "label" value.
# Output looks like: "StatusLabel"={ "label"="3" } or "StatusLabel"=(null)
RAW="$(lsappinfo info -only StatusLabel -app "$BUNDLE" 2>/dev/null || true)"

# Extract the badge number from the label value
COUNT="$(echo "$RAW" | grep -oE '"label"="[^"]*"' | head -1 | sed 's/"label"="//;s/"//')"

# Treat empty, null, or non-numeric as 0
if [[ -z "$COUNT" || "$COUNT" == "null" || ! "$COUNT" =~ ^[0-9]+$ ]]; then
  COUNT=0
fi

if [ "$COUNT" -gt 0 ]; then
  "$SB" --set "$NAME" icon="●" icon.color="$COLOR" \
                      label="$COUNT" label.color="$COLOR" \
                      drawing=on
else
  "$SB" --set "$NAME" icon="" label="" drawing=off
fi
