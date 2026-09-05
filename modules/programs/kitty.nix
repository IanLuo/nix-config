{ ... }:
# kitty terminal — transparent + blurred background.
# macOS supports real background blur (background_blur = radius); blur only
# takes effect when background_opacity < 1.0. background_tint improves text
# contrast over the blurred backdrop.
{
  flake.modules.homeManager.kitty = { ... }: {
    programs.kitty = {
      enable = true;
      settings = {
        background = "#192330"; # nightfox bg — matches the active nvim scheme
        background_opacity = "0.95";
        background_blur = "30";
        background_tint = "0.8";
        # FiraCode Nerd Font Mono — mono-spaced so nerd glyphs stay aligned
        font_family = "FiraCode Nerd Font Mono";
        font_size = "13";
        # tighten the tall FiraCode line metrics (negative px shrinks rows)
        cell_height = "10px";
        # Hide the macOS title bar but keep the rounded corners
        # (`titlebar-and-corners` would remove those too).
        hide_window_decorations = "titlebar-only";
      };
    };
  };
}
