{ pkgs, lib, ... }: {

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ianluo = { pkgs, ...}: with lib; {
    xdg.configFile.vim = {
      source = ./vim;
    };

    home.stateVersion = "21.11";

    home.packages = with pkgs; [
      git
      direnv
      curl
      wget
      zsh
      tree
      any-nix-shell
      tmate
      ruby
      alacritty
      tmux
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli
    ];

    programs.command-not-found.enable = true;

    programs.htop = {
      enable = true;
      settings.show_program_path = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    }; 

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
      '';

      initExtra = ''
        any-nix-shell zsh --info-right | source /dev/stdin
      '';

      plugins = [
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "v0.6.4";
            sha256 = "1pnxr39cayhsvggxihsfa3rqys8rr2pag3ddil01w96kw84z4id2";
          };
        }

        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.6.4";
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
        EDITOR = "vim";
      };

      shellAliases = {
        vi = "vim";
      };
    };

    programs.vim = {
      enable = true;
    };

    programs.alacritty = {
      enable = true;
    };

    programs.fzf = {
      enable = true;
    };

    programs.git = {
      enable = true;
      extraConfig = {
        core.editor = "vim";
      };
    };

    programs.gitui = {
      enable = true;
    };


    programs.tmux = {
      enable = true;
      newSession = true;
      escapeTime = 0;
      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
      ];

      extraConfig = ''
        set -g default-terminal "screen-256color
	set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        # Mouse works as expected
        set-option -g mouse on

        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
      '';
    };

    programs.tmate.enable = true;


  };

  # make sure the nix daemon is always runs
  services.nix-daemon.enable = true;
  # install a version of nix, that doesn't need 'experimental-features = nix-command flakes" in /etc/nix/nix.conf 
  # services.nix-daemon.package = pkgs.nixFlakes;


  homebrew = {
    enable = true;
    # onActivation.autoUpdate = true;
    # updates homebrew packages on activation
    # can make darwin-rebuid much slower but otherwise will do it manually
    casks = [
      "hammerspoon"      
      "amethyst"
      "alfred"
      "iina"
    ]; 
  };
} 
