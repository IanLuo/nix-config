{ ... }:
{
  flake.modules.homeManager.shell = { pkgs, lib, config, ... }: {
    programs.zsh = {
      enable = true;
      # Future default: zsh configs in XDG dir (~/.config/zsh).
      dotDir = "${config.xdg.configHome}/zsh";
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "command-not-found"
          "git"
        ];
      };

      initContent = ''
        # TERM: force screen-256color only inside tmux/screen (tmux sets its own
        # default-terminal). Leave other terminals (herdr panes, iTerm, ...) with
        # their correct TERM — a fake screen-* terminfo breaks TUI apps in herdr.
        if [[ -n "$TMUX" || "$TERM" == screen* ]]; then
          export TERM=screen-256color
        fi
        export PATH="$HOME/.local/bin:$PATH"

        any-nix-shell zsh --info-right | source /dev/stdin

        eval "$(direnv hook zsh)"

        # fzf-tab: grouped descriptions + LS_COLORS filename colors in the completion list.
        zstyle ':completion:*:descriptions' format '[%d]'
        if [[ -z $LS_COLORS ]]; then
          # minimal default (dircolors-style) so list-colors has something to parse
          export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;31:ow=1;31'
        fi
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      '';

      plugins = [
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.7.1";
            sha256 = "gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
          };
        }
        # zsh-autosuggestions intentionally NOT fetched here: autosuggestion.enable
        # above already sources the nixpkgs 0.7.1 copy — a second load would make
        # the older 0.6.4 win.
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ../../programs/zsh/p10k-config;
          file = "p10k.zsh";
        }
        # fzf-tab: replaces the zsh completion menu with an interactive fzf list.
        # Loads after oh-my-zsh/compinit because HM sources custom plugins after
        # oh-my-zsh.sh; needs `fzf` on PATH (programs.fzf, see cli.nix).
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "24105b15714bfec37989ed5c5b6e60f572253019"; # master 2026-06-04
            sha256 = "1qyaw00k1jlic17phr4wm68jvnwcyjsbvhawqxamk67v8fxx4532";
          };
        }
      ];

      shellAliases = {
        vim = "nvim";
        # modern CLI replacements
        ls = "eza";
        lt = "eza --tree";
        cat = "bat";
      };
    };
  };
}
