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
