{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # basics
      vim-sensible
      packer-nvim
      copilot-vim
      vim-tmux-navigator

      # All the lua functions I don't want to write twice.
      plenary-nvim

      # add, delete, change surroundings (it's awesome)
      nvim-surround

      # Replacing an existing text with the contents of a register
      vim-ReplaceWithRegister

      # file tree
      nvim-web-devicons
      nvim-tree-lua

      # status line
      feline-nvim

      #indent lines
      indent-blankline-nvim

      # auto close
      nvim-autopairs

      # fuzzy finder
      telescope-nvim
      telescope-fzf-native-nvim

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
      nvim-treesitter
      nvim-treesitter-parsers.python
      nvim-treesitter-parsers.lua
      nvim-treesitter-parsers.html
      nvim-treesitter-parsers.toml
      nvim-treesitter-parsers.tsx
      nvim-treesitter-parsers.swift
      nvim-treesitter-parsers.ruby
      nvim-treesitter-parsers.rust
      nvim-treesitter-parsers.dart
      nvim-treesitter-parsers.nix
      nvim-treesitter-parsers.markdown
      nvim-treesitter-parsers.make
      nvim-treesitter-parsers.latex
      nvim-treesitter-parsers.julia
      nvim-treesitter-parsers.json
      nvim-treesitter-parsers.javascript
      nvim-treesitter-parsers.ini
      nvim-treesitter-parsers.haskell
      nvim-treesitter-parsers.graphql
      nvim-treesitter-parsers.go
      nvim-treesitter-parsers.gitattributes
      nvim-treesitter-parsers.fish
      nvim-treesitter-parsers.git_config
      nvim-treesitter-parsers.git_rebase
      nvim-treesitter-parsers.elm
      nvim-treesitter-parsers.diff
      nvim-treesitter-parsers.cuda
      nvim-treesitter-parsers.cpp
      nvim-treesitter-parsers.c
      nvim-treesitter-parsers.cmake
      nvim-treesitter-parsers.bash


      # highlight selected symbol
      vim-illuminate

      # completions
      cmp-treesitter
      cmp-buffer
      cmp-path
      cmp-cmdline
      nvim-cmp
      lspkind-nvim
      cmp-nvim-lsp-document-symbol
      lspsaga-nvim      
      luasnip


      # snippets
      friendly-snippets

      # theming
      tokyonight-nvim
      catppuccin-nvim
      
      neogit
      gitsigns-nvim
      trouble-nvim
    ];

    extraPackages = with pkgs; [
      tree-sitter

      # telescope tools
      ripgrep
      fd
    ];

    extraConfig = ''
      :luafile ~/.config/nvim/init.lua
    '';
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
