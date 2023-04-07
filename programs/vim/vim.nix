{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-sensible
      wilder-nvim
      wilder-nvim
      formatter-nvim
      nvim-tree-lua
      vim-nix
      nvim-colorizer-lua

      nvim-tree-lua
      feline-nvim
      indent-blankline-nvim
      telescope-nvim
      trouble-nvim
      legendary-nvim
      dressing-nvim
      bufferline-nvim
      vim-smoothie
      numb-nvim
      leap-nvim
      nvim-ts-rainbow
      nvim-notify
      comment-nvim

      nvim-treesitter.withAllGrammars

      nvim-lspconfig
      nvim-lsp-ts-utils
      null-ls-nvim
      fidget-nvim
      vim-illuminate

      cmp-nvim-lsp
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp-signature-help
      nvim-cmp
      lspkind-nvim

      luasnip
      cmp_luasnip

      nvim-dap
      telescope-dap-nvim
      nvim-dap-ui
      nvim-dap-virtual-text

      nord-nvim
    ];

    extraPackages = with pkgs; [
      tree-sitter

      rnix-lsp
      nixpkgs-fmt
      statix

      ripgrep
      fd
    ];

    extraConfig = ''
      :luafile ~/.config/init.lua
      '';
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
