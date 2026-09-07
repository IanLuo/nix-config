{ ... }:
# sketchybar — macOS menu-bar replacement. Minimal starter bar themed to
# nightfox (#192330) to match kitty + nvim. home-manager owns the package,
# the launchd service, and writes ~/.config/sketchybar/sketchybarrc.
#
# Auto-start is fully declarative: `service.enable` makes home-manager write a
# LaunchAgent (org.nix-community.home.sketchybar) into ~/Library/LaunchAgents
# with RunAtLoad + KeepAlive, so the bar starts at login on every boot. No
# manual launchctl needed, nothing lives outside this module.
#
# NOTE (macOS TCC): the bar only renders after sketchybar is granted
# Accessibility (System Settings → Privacy & Security). TCC tracks the nix
# store path, so if the bar silently vanishes after a sketchybar update,
# re-add the new store path there.
{
  flake.modules.homeManager.sketchybar = { ... }: {
    programs.sketchybar = {
      enable = true;
      service.enable = true; # LaunchAgent: auto-start at login, keep-alive

      config = ''
        # nightfox palette (bar color is hardcoded with its alpha prefix)
        export COLOR_FG=0xffcdcecf
        export COLOR_ACCENT=0xff719cd6
        export COLOR_MUTED=0xff3f4b60

        # bar — match kitty's translucent background (opacity 0.65, blur 30;
        # kitty's tint has no sketchybar equivalent, so bump alpha if washed).
        # color is ARGB: 0xa6 = alpha 0.65 over nightfox bg.
        # Bar sits at the very top. topmost=off so the auto-hidden system menu
        # bar (System Settings → Desktop & Dock) can reveal OVER this bar for
        # its buttons, then hide again. AeroSpace's top gap keeps tiled
        # windows below the bar, so the bar stays visible without topmost.
        sketchybar --bar height=42 position=top topmost=off \
                        color=0xa6192330 blur_radius=30 \
                        corner_radius=12 \
                        margin=6 y_offset=4 padding_left=12 padding_right=12

        # item defaults
        sketchybar --default icon.font="FiraCode Nerd Font Mono:Bold:14.0" \
                            icon.color=$COLOR_FG \
                            icon.padding_left=2 icon.padding_right=2 \
                            label.font="FiraCode Nerd Font Mono:Regular:13.0" \
                            label.color=$COLOR_FG \
                            label.padding_left=2 label.padding_right=2

        # left: AeroSpace workspace indicators. Click to switch; the active
        # one is highlighted by plugins/update_spaces.sh (fired by aerospace's
        # exec-on-workspace-change).
        for ws in 1 2 3 4 5 6 7 8 9 10; do
          # Plain text indicator: active = bold white, inactive = dimmed like
          # the date. Fixed label width keeps layout stable as bold/regular
          # differ in width.
          sketchybar --add item space.$ws left \
                     --set space.$ws label="$ws" \
                             label.width=18 label.align=center \
                             padding_left=4 padding_right=4 \
                             click_script="$HOME/.nix-profile/bin/aerospace workspace $ws"
        done

        # highlight the focused space once (aerospace re-fires on changes)
        "$HOME/.config/sketchybar/plugins/update_spaces.sh"

        # left: frontmost app (icon glyph + name as separate components)
        # clear group break: front_app pl 44 + space pr 4 = 48
        sketchybar --add item front_app left \
                   --set front_app icon.font="FiraCode Nerd Font Mono:Regular:13.0" \
                           icon.padding_right=4 \
                           padding_left=44 padding_right=4 \
                           script="$HOME/.config/sketchybar/plugins/front_app.sh" \
                           --subscribe front_app front_app_switched
        "$HOME/.config/sketchybar/plugins/front_app.sh"

        # right: wifi (icon+SSID when connected, dim when not; click → network)
        sketchybar --add item wifi right \
                   --set wifi icon.font="FiraCode Nerd Font Mono:Bold:17.0" \
                           padding_left=4 padding_right=4 \
                           script="$HOME/.config/sketchybar/plugins/wifi.sh" \
                           click_script='open "x-apple.systempreferences:com.apple.Network-Settings.extension"' \
                           update_freq=60 \
                           --subscribe wifi wifi_change system_woke
        # set the icon/state immediately (script re-runs on wifi events)
        "$HOME/.config/sketchybar/plugins/wifi.sh"

        # right: battery (event-driven; click → power settings)
        sketchybar --add item battery right \
                   --set battery icon.padding_right=3 \
                           padding_left=4 padding_right=4 \
                           script="$HOME/.config/sketchybar/plugins/battery.sh" \
                           click_script='open "x-apple.systempreferences:com.apple.Battery-Settings.extension"' \
                           update_freq=120 \
                           --subscribe battery system_woke power_source_change

        # right: clock (update_freq ticks the script)
        sketchybar --add item clock right \
                   --set clock icon= icon.color=$COLOR_ACCENT \
                           padding_left=4 padding_right=4 \
                           script="sketchybar --set \$NAME label=\"\$(date '+%H:%M')\"" \
                           update_freq=10

        # render
        sketchybar --update
      '';
    };

    # Helper that re-highlights the active AeroSpace space in the bar.
    # Fired by aerospace's exec-on-workspace-change (reads the
    # AEROSPACE_FOCUSED_WORKSPACE env) and once at sketchybarrc init.
    home.file.".config/sketchybar/plugins/update_spaces.sh" = {
      executable = true;
      text = ''
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
        INACTIVE_FG="0xff3f4b60"   # COLOR_MUTED — same as the date

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
      '';
    };

    # Battery level + state (event-driven with an update_freq fallback).
    home.file.".config/sketchybar/plugins/battery.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        set -uo pipefail

        SB="$(command -v sketchybar || true)"
        [ -n "$SB" ] || SB="$HOME/.nix-profile/bin/sketchybar"

        PCT="$(pmset -g batt 2>/dev/null | grep -oE '[0-9]+%' | head -1 | tr -d '%')"
        STATE="$(pmset -g batt 2>/dev/null | grep -oE 'AC Power|Battery Power' | head -1)"
        [ -n "$PCT" ] || PCT=100

        if [ "$PCT" -ge 50 ]; then COLOR="0xff81b29a"  # nightfox green
        elif [ "$PCT" -ge 20 ]; then COLOR="0xffd19a66" # nightfox orange
        else COLOR="0xffc94f6d"; fi                     # nightfox red

        "$SB" --set battery label="$PCT%" label.color="$COLOR"
      '';
    };

    # Wi-Fi indicator: always shown — wifi icon + SSID in cyan when connected
    # (en0), dimmed icon with no label when not.
    home.file.".config/sketchybar/plugins/wifi.sh" = {
      executable = true;
      text = ''
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
      '';
    };

    # Frontmost app: nerd-glyph by app + name. Emitted via printf so the
    # codepoints survive nix encoding; extend the case map as needed.
    home.file.".config/sketchybar/plugins/front_app.sh" = {
      executable = true;
      text = ''
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
      '';
    };
  };
}
