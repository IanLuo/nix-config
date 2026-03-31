{ ... }:
{
  flake.modules.darwin.window-management = { unstable-pkgs, ... }: {
    services.yabai = {
      enable = true;
      package = unstable-pkgs.yabai;
      enableScriptingAddition = true;
      config = {
        focus_follows_mouse = "off";
        mouse_follows_focus = "off";
        window_placement = "second_child";
        window_opacity = "off";
        window_opacity_duration = "0.0";
        window_border = "on";
        window_border_placement = "inset";
        window_border_width = 2;
        window_border_radius = 3;
        active_window_border_topmost = "off";
        window_topmost = "on";
        window_shadow = "float";
        active_window_border_color = "0xff5c7e81";
        normal_window_border_color = "0xff505050";
        insert_window_border_color = "0xffd75f5f";
        active_window_opacity = "1.0";
        normal_window_opacity = "1.0";
        split_ratio = "0.50";
        auto_balance = "on";
        mouse_modifier = "fn";
        mouse_action1 = "move";
        mouse_action2 = "resize";
        layout = "bsp";
        top_padding = 10;
        bottom_padding = 10;
        left_padding = 10;
        right_padding = 10;
        window_gap = 10;
      };

      extraConfig = ''
        yabai -m rule --add app='System Settings' manage=off
        yabai -m rule --add app='WeChat' manage=off
        yabai -m rule --add app='Finder' manage=off
        yabai -m rule --add app='Activity Monitor' manage=off
        yabai -m rule --add app='Simulator' manage=on float=on
      '';
    };

    services.skhd = {
      enable = true;
      skhdConfig = ''
        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east

        alt - 1 : yabai -m space --focus 1
        alt - 2 : yabai -m space --focus 2
        alt - 3 : yabai -m space --focus 3
        alt - 4 : yabai -m space --focus 4
        alt - 5 : yabai -m space --focus 5
        alt - 6 : yabai -m space --focus 6
        alt - 7 : yabai -m space --focus 7
        alt - 8 : yabai -m space --focus 8
        alt - 9 : yabai -m space --focus 9
        alt - 0 : yabai -m space --focus 10

        alt - r : yabai -m space --rotate 90
        alt - e : yabai -m window --toggle split
        alt - m : yabai -m window --minimize
        alt - t : yabai -m window --toggle float;\
                  yabai -m window --grid 4:4:1:1:2:2
        alt - f : yabai -m window --focus mouse && \
                  yabai -m window --toggle zoom-fullscreen
        alt - 0 : yabai -m space --balance

        shift + alt - h : yabai -m window --swap west
        shift + alt - j : yabai -m window --swap south
        shift + alt - k : yabai -m window --swap north
        shift + alt - l : yabai -m window --swap east

        shift + cmd - h : yabai -m window --warp west
        shift + cmd - j : yabai -m window --warp south
        shift + cmd - k : yabai -m window --warp north
        shift + cmd - l : yabai -m window --warp east

        shift + alt - 1 : yabai -m window --space 1
        shift + alt - 2 : yabai -m window --space 2
        shift + alt - 3 : yabai -m window --space 3
        shift + alt - 4 : yabai -m window --space 4
        shift + alt - 5 : yabai -m window --space 5
        shift + alt - 6 : yabai -m window --space 6
        shift + alt - 7 : yabai -m window --space 7
        shift + alt - 8 : yabai -m window --space 8
        shift + alt - 9 : yabai -m window --space 9
        shift + alt - 0 : yabai -m window --space 10
      '';
    };
  };

  flake.modules.nixos.window-management = { pkgs, ... }: {
    services.xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
          i3blocks
        ];
      };
    };

    services.displayManager.defaultSession = "xfce+i3";
  };
}
