{ inputs, lib, ... }:
let
  mkPkgsFrom = nixpkgsInput: system:
    import nixpkgsInput {
      inherit system;
      config.allowUnfree = true;
    };

  customPackageDefinitions = {
    gstack = {
      src = inputs.gstack-src;
      version = "0.14.5.0";
      bun2nix = inputs.bun2nix;
    };

    specify-cli = {
      src = inputs.specify-cli-src;
      version = "0.3.2";
    };
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

    mkGstack = pkgs:
      let def = customPackageDefinitions.gstack;
      in pkgs.callPackage ../packages/custom/gstack.nix {
        src = def.src;
        version = def.version;
        bun2nix = def.bun2nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };

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
