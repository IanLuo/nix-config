{
  description = "My computer setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, ... }:
    let
      stateVersion = "25.05";

      # Centralized host and user configuration
      systems = {
        "aarch64-darwin" = {
          pkgs = import nixpkgs { system = "aarch64-darwin"; config.allowUnfree = true; };
          unstable-pkgs = import nixpkgs { system = "aarch64-darwin"; config.allowUnfree = true; };
        };
        "aarch64-linux" = {
          pkgs = import nixpkgs { system = "aarch64-linux"; config.allowUnfree = true; };
          unstable-pkgs = import nixpkgs { system = "aarch64-linux"; config.allowUnfree = true; };
        };
      };

      # System-specific packages
      systemPackagesFor = system: systems.${system}.pkgs.callPackage ./programs/systemPackages.nix {
        pkgs = systems.${system}.pkgs;
        unstable-pkgs = systems.${system}.unstable-pkgs;
        inherit system;
      };

      # Host configurations
      users = {
        "ianluo" = {
          system = "aarch64-darwin";
          host = "ianluo.local";
          isNixOS = false;
        };
        "ian" = { # For NixOS machine
          system = "aarch64-linux";
          host = "nixos-vm";
          isNixOS = true;
        };
        "ian-linux-dev" = { # For non-NixOS Linux machine
          system = "aarch64-linux";
          host = "linux-dev";
          isNixOS = false;
        };
      };

      # Generate configurations for all users
      generatedConfigurations = nixpkgs.lib.mapAttrs (username: userConfig:
        let
          system = userConfig.system;
          host = userConfig.host;
          isNixOS = userConfig.isNixOS;
          pkgs = systems.${system}.pkgs;
          unstable-pkgs = systems.${system}.unstable-pkgs;
          systemPackages = systemPackagesFor system;
          specialArgs = { inherit inputs stateVersion username systemPackages unstable-pkgs; };
        in
        if isNixOS then {
          # NixOS Configuration
          nixosConfigurations = {
            "${host}" = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                ./nixos/configuration.nix
                home-manager.nixosModules.home-manager {
                  home-manager.users.${username} = import ./linux;
                  home-manager.extraSpecialArgs = specialArgs;
                }
              ];
            };
          };
        } else if system == "aarch64-darwin" then {
          # Darwin Configuration
          darwinConfigurations = {
            "${username}" = nix-darwin.lib.darwinSystem {
              inherit system;
              modules = [
                { system.stateVersion = 6; }
                { nix.enable = false; }
                ./macos
                home-manager.darwinModules.home-manager
              ];
              specialArgs = specialArgs // { user = username; };
            };
          };
        } else {
          # Home Manager Configuration for non-NixOS Linux
          homeConfigurations = {
            "${username}" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                ./linux
              ];
              extraSpecialArgs = specialArgs;
            };
          };
        }
      ) users;

      # Helper to merge all generated configurations
      mergeConfigurations = nixpkgs.lib.foldl' (nixpkgs.lib.recursiveUpdate) {};

    in
    (mergeConfigurations (nixpkgs.lib.attrValues generatedConfigurations)) // {
      formatter = nixpkgs.lib.mapAttrs (system: _: systems.${system}.pkgs.nixpkgs-fmt) systems;
    };
}
