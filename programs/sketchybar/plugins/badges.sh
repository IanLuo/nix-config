#!/usr/bin/env bash
# Badge-count indicator for messaging apps. Polls via lsappinfo and
# shows a colored dot + count when badges > 0, hides when 0.
# Called by sketchybar with $NAME set to the item name (badge.teams, etc).
set -uo pipefail

SB="$(command -v sketchybar || true)"
[ -n "$SB" ] || SB="$HOME/.nix-profile/bin/sketchybar"

NAME="${NAME:-}"
[ -n "$NAME" ] || exit 0

# Shared badge accent — nightfox orange, warm enough to pop on the bar
BADGE_COLOR="0xfff4a261"

# Map item name → bundle ID + nerd font icon
case "$NAME" in
  badge.teams)    BUNDLE="com.microsoft.teams2"       ICON="󰻞" ;;  # nf-md-chat
  badge.outlook)  BUNDLE="com.microsoft.Outlook"       ICON="󰇮" ;;  # nf-md-email
  badge.slack)    BUNDLE="com.tinyspeck.slackmacgap"   ICON="󱋊" ;;  # nf-md-message_text
  badge.messages) BUNDLE="com.apple.MobileSMS"         ICON="󰍡" ;;  # nf-md-message_reply
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
  "$SB" --set "$NAME" icon="$ICON" icon.color="$BADGE_COLOR" \
                      icon.font="FiraCode Nerd Font Mono:Bold:16.0" \
                      label="$COUNT" label.color="$BADGE_COLOR" \
                      label.font="FiraCode Nerd Font Mono:Bold:13.0" \
                      drawing=on
else
  "$SB" --set "$NAME" icon="" label="" drawing=off
fi
