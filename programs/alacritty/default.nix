{ pkgs, lib, config, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Fira Code";
          style = "Regular";
        };
      };
      window = {
        padding = {
          x = 10;
          y = 10;
        };
      };
    };
  };
}
