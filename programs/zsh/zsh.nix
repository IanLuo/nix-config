{ pkgs, lib, brewBinPrefix, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "command-not-found"
        "git"
        "tmux"
      ];
    };

    initExtraBeforeCompInit = ''
            if [ -z "$__NIX_DARWIN_SET_ENVIRONMENT_DONE" ]; then
            . /nix/store/w5ry32li85iywmgmz6f8gcrdb2ixnl96-set-environment
            fi

      # Nix
            if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
            fi
      # End Nix

            if [ -e '$HOME/.nix-profile/etc/profile.d/nix.sh' ]; then 
            . $HOME/.nix-profile/etc/profile.d/nix.sh;
            fi # added by Nix installer

            if [ "$TMUX" = "" ]; then tmux attach; fi

            export TERM=screen-256color

    '';

    initExtra = ''
      any-nix-shell zsh --info-right | source /dev/stdin
      eval "$(${brewBinPrefix}/brew shellenv)" 
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
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    localVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      vi = "nvim";
    };

    shellAliases = {
      vim = "nvim";
    };
  };

}
