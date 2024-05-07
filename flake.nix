{
  description = "My computer setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Emacs
    # emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = inputs@{ self, ... }:
    let
      darwinUsers = [ "ianluo" ];
      darwinHosts = [ "CDU-L737HCJ9FJ" "ianluo"];
      linuxUsers = [ "ian" "nixos"];
      myDarwin = "aarch64-darwin";
      aarchLinux = "aarch64-linux";
      stateVersion = "23.05";
      darwinPkgs = import inputs.nixpkgs {
        system = myDarwin;
        config.allowUnfree = true;
      };
      aarchLinuxPkgs = import inputs.nixpkgs {
        system = aarchLinux;
        config.allowUnfree = true;
      };

      systemPackages = aarchLinuxPkgs.callPackage ./programs/systemPackages.nix { pkgs = darwinPkgs; }; 
    in {
      darwinConfigurations = darwinPkgs.lib.attrsets.genAttrs darwinHosts (host:
        inputs.darwin.lib.darwinSystem {

          pkgs = darwinPkgs;
          
          system = myDarwin;
          
          modules = [
            inputs.home-manager.darwinModules.home-manager
            ./macos 
            ./misc/fonts.nix
          ];

          specialArgs = { inherit inputs stateVersion systemPackages; 
            user = "ianluo";
          };
        });

      homeConfigurations = aarchLinuxPkgs.lib.attrsets.genAttrs linuxUsers (user: 
        inputs.home-manager.lib.homeManagerConfiguration {

          pkgs = inputs.nixpkgs.legacyPackages.${aarchLinux};

          modules = [
            ./linux
          ];

          extraSpecialArgs = { inherit inputs stateVersion user systemPackages; };
      });
       
      nixosConfigurations."nixos" =
      let 
        user = "ian";
      in
        inputs.nixpkgs.lib.nixosSystem {

        pkgs = inputs.nixpkgs.legacyPackages.${aarchLinux};
          modules = [
            ./nixos/configuration.nix 
            inputs.home-manager.nixosModules.home-manager {
              home-manager.users.${user} = import ./linux;

              home-manager.extraSpecialArgs = { 
                inherit inputs stateVersion user systemPackages;
              };
            }
          ];
        };

        formatter.${aarchLinux} = inputs.nixpkgs.nixpkgs-fmt;
        defaultPackage.${aarchLinux} = inputs.home-manager.defaultPackage.${aarchLinux};
    };
}
