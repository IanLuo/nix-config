{ config, inputs, ... }:
let
  topConfig = config;
  system = "aarch64-linux";
  user = "ian";
in {
  flake.modules.nixos.nixos-vm-base = { config, pkgs, ... }: {
    assertions = [
      {
        assertion = user != "";
        message = "NixOS user must not be empty.";
      }
      {
        assertion = builtins.elem "wheel" config.users.users.${user}.extraGroups;
        message = "NixOS user must keep wheel access.";
      }
    ];

    imports = with topConfig.flake.modules.nixos; [
      system-foundation
      window-management
      remote-access
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        firefox
        tree
        neovim
        git
      ];
    };

    system.stateVersion = "24.11";

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.${user} = {
      imports = [
        topConfig.flake.modules.homeManager.base
        topConfig.flake.modules.homeManager.system-packages
        topConfig.flake.modules.homeManager.cli
        topConfig.flake.modules.homeManager.shell
        topConfig.flake.modules.homeManager.tmux
        topConfig.flake.modules.homeManager.editor
        topConfig.flake.modules.homeManager."ai-home"
      ];

      home.username = user;
      home.homeDirectory = "/home/${user}";

      programs.aiHome = {
        enable = true;
        sources.gstack.package = topConfig.repo.mkGstack pkgs;
      };
    };
  };

  flake.modules.nixos.nixos-vm = { config, pkgs, ... }: {
    imports = [
      topConfig.flake.modules.nixos.nixos-vm-base
      ./_nixos-vm/hardware-configuration.nix
    ];
  };

  flake.nixosConfigurations.nixos-vm = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      topConfig.flake.modules.nixos.nixos-vm
      inputs.home-manager.nixosModules.home-manager
    ];
  };
}
