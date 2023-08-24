{ pkgs, lib, config, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [./config/alacritty.yaml];
    };
  };

  xdg.configFile.alacritty = {
    source = ./config;
    recursive = true;
  };
}
