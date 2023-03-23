{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = builtins.readFile ./vimrc;

    plugins = with pkgs.vimPlugins; [
      wilder-nvim
      tcomment_vim
      wilder-nvim
      formatter-nvim
      fzf-vim
      fzfWrapper
      vim-rails
      nvim-tree-lua
      vim-nix
      nvim-colorizer-lua
    ];
  };
}
