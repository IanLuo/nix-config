{ pkgs, lib, ... }:
let 
  # copilot-vim = pkgs.stdenv.mkDerivation {
  #   name = "copilot-vim";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "github";
  #     repo = "copilot.vim";
  #     rev = "v1.26.0";
  #     sha256 = "sha256-tcLrto1Y66MtPnfIcU2PBOxqE0xilVl4JyKU6ddS7bA="; 
  #   };
  # };
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # basics
      vim-sensible
      # packer-nvim  
      # copilot-vim  # TODO: Enable unfree packages for Copilot
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
      rainbow-delimiters-nvim

      # notify window
      nvim-notify

      # commenting 
      comment-nvim

      # syntax highlighting
      nvim-treesitter.withAllGrammars


      # highlight selected symbol
      vim-illuminate

      # LSP and completions
      nvim-lspconfig
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      # luasnip  # Temporarily disabled due to loading issues
      # cmp_luasnip
      cmp-treesitter
      cmp-buffer
      cmp-path
      cmp-cmdline
      nvim-cmp
      lspkind-nvim
      cmp-nvim-lsp-document-symbol
      lspsaga-nvim


      # snippets
      # friendly-snippets  # Temporarily disabled due to loading issues

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
