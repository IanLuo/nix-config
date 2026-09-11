{ ... }:
# Ghostty terminal — transparent + blurred background, hidden titlebar.
# Mirrors the kitty look (modules/programs/kitty.nix): nightfox bg,
# opacity/blur, FiraCode Nerd Font Mono. (No background_tint in ghostty.)
{
  flake.modules.homeManager.ghostty = { pkgs, ... }: {
    programs.ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        background = "192330"; # nightfox bg
        background-opacity = 0.85;
        background-blur-radius = 30;
        font-family = "FiraCode Nerd Font Mono";
        font-size = 13;
        macos-titlebar-style = "hidden";
      };
    };
  };
}
