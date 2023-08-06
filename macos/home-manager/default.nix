{ pkgs
, lib
, inputs
, stateVersion 
, user
, ... 
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${user} = { pkgs, ... }:
  with lib // pkgs; {
    home.stateVersion = stateVersion; 
    home.packages = [
      git
      direnv
      curl
      wget
      zsh
      tree
      any-nix-shell
      tmate
      tmux
      nodejs
      dbeaver
      iterm2
      element-desktop
      discord
      fd
      raycast
      ripgrep
      docker
      podman
      lorri
      nerdfonts 
    ] ++ optionals stdenv.isDarwin [
      m-cli
    ];

    imports = (import ../../programs).packages ++ [ inputs.nix-doom-emacs.hmModule ];

    programs.command-not-found.enable = true;

    programs.htop = {
      enable = true;
      settings.show_program_path = true;
    };

    programs.fzf = {
      enable = true;
    };

    programs.git = {
      enable = true;
      extraConfig = {
        core.editor = "vi";
      };
    };

    programs.tmate.enable = true;
  };
}
