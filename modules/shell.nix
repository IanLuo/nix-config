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
        eval "$(direnv hook bash)"
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
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "0.6.4";
            sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
          };
        }
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ../programs/zsh/p10k-config;
          file = "p10k.zsh";
        }
      ];

      shellAliases = {
        vim = "nvim";
      };
    };
  };
}
