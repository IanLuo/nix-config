{
  description = "My computer setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, ... }:
    let
      darwinUser = "ianluo";
      darwinHost = "CDU-L737HCJ9FJ";
      linuxUsers = [ "ian" "nixos"];
      myDarwin = "aarch64-darwin";
      aarchLinux = "aarch64-linux";
      stateVersion = "25.05";
      darwinPkgs = import inputs.nixpkgs {
        system = myDarwin;
        config.allowUnfree = true;
      };
      darwinPkgsUnstable = import inputs.nixpkgs-unstable {
        system = myDarwin;
        config.allowUnfree = true;
      };
      aarchLinuxPkgs = import inputs.nixpkgs {
        system = aarchLinux;
        config.allowUnfree = true;
      };
      aarchLinuxPkgsUnstable = import inputs.nixpkgs-unstable {
        system = aarchLinux;
        config.allowUnfree = true;
      };

      darwinSystemPackages = darwinPkgs.callPackage ./programs/systemPackages.nix {
        pkgs = darwinPkgs;
        unstable-pkgs = darwinPkgsUnstable;
        system = myDarwin;
      };
      linuxSystemPackages = aarchLinuxPkgs.callPackage ./programs/systemPackages.nix {
        pkgs = aarchLinuxPkgs;
        unstable-pkgs = aarchLinuxPkgsUnstable;
        system = aarchLinux;
      };
    in {
      darwinConfigurations.${darwinHost} =
        inputs.nix-darwin.lib.darwinSystem {

          system = myDarwin;

          modules = [
            { system.stateVersion = 6; }
            ./macos
            inputs.home-manager.darwinModules.home-manager
          ];

          specialArgs = { inherit inputs stateVersion;
            systemPackages = darwinSystemPackages;
            user = darwinUser;
          };
        };

      homeConfigurations = aarchLinuxPkgs.lib.attrsets.genAttrs linuxUsers (user:
        inputs.home-manager.lib.homeManagerConfiguration {

          modules = [
            ./linux
          ];

          extraSpecialArgs = { inherit inputs stateVersion user;
            systemPackages = linuxSystemPackages;
          };
      });

      nixosConfigurations."nixos" =
      let
        user = "ian";
      in
        inputs.nixpkgs.lib.nixosSystem {
          system = aarchLinux;
          modules = [
            ./nixos/configuration.nix
            inputs.home-manager.nixosModules.home-manager {
              home-manager.users.${user} = import ./linux;

              home-manager.extraSpecialArgs = {
                inherit inputs stateVersion user;
                systemPackages = linuxSystemPackages;
              };
            }
          ];
        };

        formatter.${aarchLinux} = inputs.nixpkgs.nixpkgs-fmt;
        defaultPackage.${aarchLinux} = inputs.home-manager.defaultPackage.${aarchLinux};
    };
}
