{ pkgs, lib, config, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [./config/alacritty.toml];
    };
  };

  xdg.configFile.alacritty = {
    source = ./config;
    recursive = true;
  };
}
