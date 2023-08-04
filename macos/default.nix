{ pkgs, lib, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ianluo = { pkgs, ... }: with lib;
    {
      home.stateVersion = "23.05";

    home.packages = with pkgs; [
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
      rigprep
    ] ++ lib.optionals stdenv.isDarwin [
      m-cli
    ];

    imports = [
      ../programs/vim/vim.nix
      ../programs/tmux/tmux.nix
      ../programs/gitui/gitui.nix
      (import ../programs/zsh/zsh.nix { inherit pkgs lib; })
    ];

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


  # make sure the nix daemon is always runs
  services.nix-daemon.enable = true;
  # install a version of nix, that doesn't need 'experimental-features = nix-command flakes" in /etc/nix/nix.conf 
  # services.nix-daemon.package = pkgs.nixFlakes;
} 
