{
pkgs
, ...}:

{
  services.yabai = {
    enable = true;
    # temporary workaround for https://github.com/ryan4yin/nix-config/issues/51
    package = pkgs.yabai.overrideAttrs (oldAttrs: rec {
      version = "6.0.7";
      src =
        if pkgs.stdenv.isAarch64
        then
          (pkgs.fetchzip {
            url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
            hash = "sha256-hZMBXSCiTlx/37jt2yLquCQ8AZ2LS3heIFPKolLub1c=";
          })
        else
          (pkgs.fetchFromGitHub {
            owner = "koekeishiya";
            repo = "yabai";
            rev = "v${version}";
            hash = "sha256-vWL2KA+Rhj78I2J1kGItJK+OdvhVo1ts0NoOHIK65Hg=";
          });
    });
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse          = "off";
      mouse_follows_focus          = "on";
      window_placement             = "second_child";
      window_opacity               = "off";
      window_opacity_duration      = "0.0";
      window_border                = "on";
      window_border_placement      = "inset";
      window_border_width          = 2;
      window_border_radius         = 3;
      active_window_border_topmost = "off";
      window_topmost               = "on";
      window_shadow                = "float";
      active_window_border_color   = "0xff5c7e81";
      normal_window_border_color   = "0xff505050";
      insert_window_border_color   = "0xffd75f5f";
      active_window_opacity        = "1.0";
      normal_window_opacity        = "1.0";
      split_ratio                  = "0.50";
      auto_balance                 = "on";
      mouse_modifier               = "fn";
      mouse_action1                = "move";
      mouse_action2                = "resize";
      layout                       = "bsp";
      top_padding                  = 10;
      bottom_padding               = 10;
      left_padding                 = 10;
      right_padding                = 10;
      window_gap                   = 10;
    };

    extraConfig = ''
      yabai -m rule --add app='System Settings' manage=off
      yabai -m rule --add app='WeChat' manage=off
      yabai -m rule --add app='Finder' manage=off
    '';
  };
}
