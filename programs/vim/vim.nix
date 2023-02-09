{ pkgs, ... }:
{
  programs.vim = {
    enable = true;

    extraConfig = builtins.readFile ./vimrc;

    plugins = with pkgs.vimPlugins; [
      fzf-vim
      fzfWrapper
    ];
  };
}
