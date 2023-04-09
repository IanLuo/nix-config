{ pkgs, ... }:

let
  _ = pkgs.vimUtils.buildVimPlugin {
    name = "my-nord-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "shaunsingh";
      repo = "nord.nvim";
      sha256 = "sha256-0Dg7A7CX8zWCHT/xZFUv/cQEAp+1naYno2IMHCBU6wc=";
      rev = "fab04b2dd4b64f4b1763b9250a8824d0b5194b8f";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # basics
      vim-sensible

      # Add syntax/detection/indentation for langs
      dart-vim-plugin

      # ruby and rails
      vim-rails
      vim-ruby

      # file tree
      nvim-web-devicons
      nvim-tree-lua

      # status line
      feline-nvim

      # git info
      gitsigns-nvim

      #indent lines
      indent-blankline-nvim

      # auto close
      nvim-autopairs

      # fuzzy finder
      telescope-nvim

      # diagnostics window
      trouble-nvim

      # keybindings window
      legendary-nvim

      # better native input/select windows
      dressing-nvim

      # tabs
      bufferline-nvim

      # smooth scrolling
      vim-smoothie

      # peek line search 
      numb-nvim

      # fast navigation
      leap-nvim

      #rainbow brackets
      nvim-ts-rainbow

      # notify window
      nvim-notify

      # commenting 
      comment-nvim

      # syngax highlighting
      nvim-treesitter.withAllGrammars

      # lsp
      nvim-lspconfig
      nvim-lsp-ts-utils

      # lsp status window
      fidget-nvim

      # linting
      null-ls-nvim

      # code action sign
      nvim-lightbulb

      # highlight selected symbol
      vim-illuminate

      # completions
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp-signature-help
      nvim-cmp
      lspkind-nvim

      # snippets
      luasnip
      cmp_luasnip

      # debug adapter protocol
      nvim-dap
      telescope-dap-nvim
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-dap

      vim-nix
      nvim-colorizer-lua

      # theming
      nord-nvim
      tokyonight-nvim
      lualine-nvim
    ];

    extraPackages = with pkgs; [
      tree-sitter

      # language server
      nodePackages.bash-language-server

      # dart
      dart


      # nix
      rnix-lsp
      nixpkgs-fmt
      statix

      # python
      pyright
      black

      # web

      # telescope tools
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
