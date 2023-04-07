{ pkgs, lib, ... }: 
let brewBinPrefix = if pkgs.system == "aarch64-darwin" then "/opt/homebrew/bin" else "/usr/local/bin";
in

  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.ianluo = { pkgs, ...}: with lib; {

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

      imports = [
        ../programs/vim/vim.nix 
        ../programs/tmux/tmux.nix
        ../programs/gitui/gitui.nix
        (import ../programs/zsh/zsh.nix { inherit pkgs lib brewBinPrefix; })
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

      

      programs.alacritty = {
        enable = true;
      };

      programs.fzf = {
        enable = true;
      };

      programs.git = {
        enable = true;
        extraConfig = {
          core.editor = "nvim";
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
      "hammerspoon"      
      "amethyst"
      "iina"
      "iterm2"
    ]; 

    brews = [
      "xcodegen"
    ];
  };
} 
