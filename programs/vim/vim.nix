{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # basics
      vim-sensible
      packer-nvim
      copilot-vim

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

      # highlight selected symbol
      vim-illuminate

      # completions
      cmp-buffer
      cmp-path
      cmp-cmdline
      nvim-cmp
      lspkind-nvim
      cmp-nvim-lsp-document-symbol


      # snippets
      friendly-snippets

      # theming
      tokyonight-nvim
    ];

    extraPackages = with pkgs; [
      tree-sitter

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
