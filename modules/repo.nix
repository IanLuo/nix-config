{ inputs, lib, ... }:
let
  mkPkgsFrom = nixpkgsInput: system:
    import nixpkgsInput {
      inherit system;
      config.allowUnfree = true;
    };

  customPackageDefinitions = {

  };
in {
  options.repo = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  # Allow multiple host files to each define a homeConfiguration.
  # raw (not anything): values stay lazy — anything's merge forces configs.
  options.flake.homeConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
  };

  config.repo = rec {
    stateVersion = "25.05";

    mkPkgs = mkPkgsFrom inputs.nixpkgs;
    mkStablePkgs = mkPkgsFrom inputs.nixpkgs-stable;
    mkUnstablePkgs = mkPkgs;

    inherit customPackageDefinitions;


    mkSystemPackages = system:
      let
        pkgs = mkStablePkgs system;
        unstable-pkgs = mkUnstablePkgs system;
      in
      pkgs.callPackage ../packages/default.nix {
        inherit pkgs unstable-pkgs system customPackageDefinitions;
      };
  };
}
