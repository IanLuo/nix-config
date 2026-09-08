#!/usr/bin/env bash
set -uo pipefail

SKETCHYBAR="$(command -v sketchybar || true)"
[ -n "$SKETCHYBAR" ] || SKETCHYBAR="$HOME/.nix-profile/bin/sketchybar"
AERO="$(command -v aerospace || true)"
[ -n "$AERO" ] || AERO="$HOME/.nix-profile/bin/aerospace"

FOCUSED="$(printenv AEROSPACE_FOCUSED_WORKSPACE || true)"
if [ -z "$FOCUSED" ]; then
  FOCUSED="$("$AERO" list-workspaces --focused 2>/dev/null || echo 1)"
fi

# Active workspace = bold white number; inactive = dimmed like the
# date label.
ACTIVE_FONT="FiraCode Nerd Font Mono:Bold:13.0"
ACTIVE_FG="0xffffffff"
INACTIVE_FONT="FiraCode Nerd Font Mono:Regular:12.0"
INACTIVE_FG="0xff000000"

# A workspace is "used" (gets an indicator) if it is the focused one
# or currently contains at least one window. Empty workspaces are
# hidden so the bar only shows what really exists.
USED=""
for ws in $("$AERO" list-workspaces --all 2>/dev/null); do
  if [ "$ws" = "$FOCUSED" ]; then
    USED="$USED $ws"
  elif [ -n "$("$AERO" list-windows --workspace "$ws" 2>/dev/null)" ]; then
    USED="$USED $ws"
  fi
done

for ws in 1 2 3 4 5 6 7 8 9 10; do
  case " $USED " in
    *" $ws "*)
      if [ "$ws" = "$FOCUSED" ]; then
        "$SKETCHYBAR" --set "space.$ws" drawing=on label.font="$ACTIVE_FONT" label.color="$ACTIVE_FG"
      else
        "$SKETCHYBAR" --set "space.$ws" drawing=on label.font="$INACTIVE_FONT" label.color="$INACTIVE_FG"
      fi
      ;;
    *)
      "$SKETCHYBAR" --set "space.$ws" drawing=off 2>/dev/null || true
      ;;
  esac
done
