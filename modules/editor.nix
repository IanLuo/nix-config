{ ... }:
{
  flake.modules.homeManager.editor = { pkgs, lib, ... }:
    let
      vimConfigPath = ../programs/vim/config;
    in {
      home.activation.removeLegacyNeovimPacker = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ -d "$HOME/.local/share/nvim/site/pack/packer" ]; then
          rm -rf "$HOME/.local/share/nvim/site/pack/packer"
        fi
      '';

      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        plugins = with pkgs.vimPlugins; [
          vim-sensible
          vim-tmux-navigator
          plenary-nvim
          nvim-surround
          vim-ReplaceWithRegister
          nvim-web-devicons
          nvim-tree-lua
          lualine-nvim
          indent-blankline-nvim
          nvim-autopairs
          telescope-nvim
          telescope-fzf-native-nvim
          legendary-nvim
          dressing-nvim
          bufferline-nvim
          vim-smoothie
          numb-nvim
          leap-nvim
          rainbow-delimiters-nvim
          nvim-notify
          comment-nvim
          nvim-treesitter.withAllGrammars
          vim-illuminate
          nvim-lspconfig
          cmp-nvim-lsp
          cmp-nvim-lsp-signature-help
          cmp-treesitter
          cmp-buffer
          cmp-path
          cmp-cmdline
          nvim-cmp
          lspkind-nvim
          cmp-nvim-lsp-document-symbol
          lspsaga-nvim
          tokyonight-nvim
          catppuccin-nvim
          neogit
          gitsigns-nvim
          trouble-nvim
        ];

        extraPackages = with pkgs; [
          tree-sitter
          pyright
          nixd
          rubyPackages.ruby-lsp
          ripgrep
          fd
        ];

        extraConfig = ''
          :luafile ~/.config/nvim/init.lua
        '';
      };

      xdg.configFile.nvim = {
        source = vimConfigPath;
        recursive = true;
      };
    };
}
