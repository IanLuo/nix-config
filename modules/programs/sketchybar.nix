{ ... }:
# sketchybar — nightfox menu-bar (AeroSpace spaces, front_app, wifi, battery,
# clock). All bash lives as plain files in programs/sketchybar/ (no nix-string
# escaping); this module installs sketchybar, writes them to ~/.config/sketchybar/,
# and manages the LaunchAgent (auto-start at login, KeepAlive).
#
# NOTE (macOS TCC): the bar only renders after sketchybar is granted
# Accessibility (System Settings → Privacy & Security). TCC tracks the nix
# store path, so re-grant it after a sketchybar update.
{
  flake.modules.homeManager.sketchybar = { ... }: {
    programs.sketchybar = {
      enable = true;
      service.enable = true; # LaunchAgent: auto-start at login, keep-alive
      config = builtins.readFile ../../programs/sketchybar/sketchybarrc;
    };

    home.file = {
      ".config/sketchybar/plugins/update_spaces.sh" = {
        source = ../../programs/sketchybar/plugins/update_spaces.sh;
        executable = true;
      };
      ".config/sketchybar/plugins/front_app.sh" = {
        source = ../../programs/sketchybar/plugins/front_app.sh;
        executable = true;
      };
      ".config/sketchybar/plugins/wifi.sh" = {
        source = ../../programs/sketchybar/plugins/wifi.sh;
        executable = true;
      };
      ".config/sketchybar/plugins/battery.sh" = {
        source = ../../programs/sketchybar/plugins/battery.sh;
        executable = true;
      };
    };
  };
}
