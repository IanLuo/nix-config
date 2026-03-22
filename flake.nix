{
  description = "My computer setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    opencode.url = "github:anomalyco/opencode";
    specify-cli-src = {
      url = "github:github/spec-kit/v0.3.2";
      flake = false;
    };
  };

  outputs = inputs@{ nix-darwin, home-manager, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      stateVersion = "25.05";
      customPackageDefinitions = {
        specify-cli = {
          src = inputs.specify-cli-src;
          version = "0.3.2";
        };
      };

      mkPkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      mkUnstablePkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      mkSystemPackages = system:
        let
          pkgs = mkPkgs system;
          unstable-pkgs = mkUnstablePkgs system;
        in
        pkgs.callPackage ./modules/shared/packages/default.nix {
          inherit pkgs unstable-pkgs system;
          inherit customPackageDefinitions;
        };

      mkSpecialArgs = { system, user }: {
        inherit inputs stateVersion user;
        unstable-pkgs = mkUnstablePkgs system;
        systemPackages = mkSystemPackages system;
      };

      darwinConfiguration =
        let
          system = "aarch64-darwin";
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            ./hosts/darwin/ianluo.nix
            home-manager.darwinModules.home-manager
          ];
          specialArgs = mkSpecialArgs {
            inherit system;
            user = "ianluo";
          };
        };

      nixosConfiguration =
        let
          system = "aarch64-linux";
        in
        lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/nixos/nixos-vm.nix
            ./nixos/hardware-configuration.nix
            home-manager.nixosModules.home-manager
          ];
          specialArgs = mkSpecialArgs {
            inherit system;
            user = "ian";
          };
        };

      linuxHomeConfiguration =
        let
          system = "aarch64-linux";
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          modules = [
            ./hosts/home/ian-linux-dev.nix
          ];
          extraSpecialArgs = mkSpecialArgs {
            inherit system;
            user = "ian-linux-dev";
          };
        };
    in {
      darwinConfigurations.ianluo = darwinConfiguration;

      nixosConfigurations.nixos-vm = nixosConfiguration;

      homeConfigurations.ian-linux-dev = linuxHomeConfiguration;

      checks = import ./checks {
        inherit home-manager mkPkgs mkSpecialArgs stateVersion;
        inherit darwinConfiguration linuxHomeConfiguration nixosConfiguration;
      };

      formatter = {
        aarch64-darwin = (mkPkgs "aarch64-darwin").nixpkgs-fmt;
        aarch64-linux = (mkPkgs "aarch64-linux").nixpkgs-fmt;
      };
    };
}
