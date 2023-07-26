{ pkgs, lib, ... }:
let brewBinPrefix = if pkgs.system == "aarch64-darwin" then "/opt/homebrew/bin" else "/usr/local/bin";
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ianluo = { pkgs, ... }: with lib; {
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
      devbox
    ] ++ lib.optionals stdenv.isDarwin [
      m-cli
    ];

    imports = [
      ../programs/vim/vim.nix
      ../programs/alacritty/alacritty.nix
      ../programs/tmux/tmux.nix
      ../programs/gitui/gitui.nix
      (import ../programs/zsh/zsh.nix { inherit pkgs lib brewBinPrefix; })
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


  homebrew = {
    enable = true;
    onActivation.autoUpdate = false;
    # updates homebrew packages on activation
    # can make darwin-rebuid much slower but otherwise will do it manually
    brewPrefix = brewBinPrefix;
    casks = [
      "raycast"
    ];

    brews = [
      "xcodegen"
    ];
  };
} 
