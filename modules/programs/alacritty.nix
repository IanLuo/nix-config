{ ... }:
# alacritty terminal — transparent + blurred background, hidden titlebar.
# Mirrors the kitty look (modules/programs/kitty.nix): same nightfox bg,
# opacity/blur, and FiraCode Nerd Font Mono. No tint (kitty-only) and no
# corner granularity — decorations "None" removes the whole titlebar.
{
  flake.modules.homeManager.alacritty = { ... }: {
    programs.alacritty = {
      enable = true;
      settings = {
        colors.primary.background = "#192330"; # nightfox bg
        window = {
          opacity = 0.65;
          blur = true;
          decorations = "None";
        };
      };
    };
  };
}
