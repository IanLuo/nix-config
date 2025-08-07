{
  description = "My computer setup";

  inputs = {
    # determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #lix-module = {
    #  url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    # Emacs
    # emacs-overlay.url = "github:nix-community/emacs-overlay";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = inputs@{ self, nix-darwin, ... }:
    let
      darwinUsers = [ "ianluo" ];
      darwinHosts = [ "CDU-L737HCJ9FJ" "ianluo"];
      linuxUsers = [ "ian" "nixos"];
      myDarwin = "aarch64-darwin";
      aarchLinux = "aarch64-linux";
      stateVersion = "24.11";
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

      systemPackages = aarchLinuxPkgs.callPackage ./programs/systemPackages.nix { 
        pkgs = darwinPkgs; 
        unstable-pkgs = darwinPkgsUnstable;
        system = myDarwin;
      };
    in {
      darwinConfigurations = darwinPkgs.lib.attrsets.genAttrs darwinHosts (host:
        inputs.nix-darwin.lib.darwinSystem {

          pkgs = darwinPkgs;

          system = myDarwin;

          modules = [
	    { system.stateVersion = 1; }
            # lix-module.nixosModules.default
            # determinate.darwinModules.default
            ./macos
            inputs.home-manager.darwinModules.home-manager
            # ./misc/fonts.nix
          ];

          specialArgs = { inherit inputs stateVersion systemPackages;
            user = "ianluo";
          };
        });

      homeConfigurations = aarchLinuxPkgs.lib.attrsets.genAttrs linuxUsers (user:
        inputs.home-manager.lib.homeManagerConfiguration {

          pkgs = aarchLinuxPkgs;  # Use the allowUnfree enabled package set

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

        pkgs = aarchLinuxPkgs;  # Use the allowUnfree enabled package set
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
