{ inputs, lib, ... }:
let
  mkPkgsFrom = nixpkgsInput: system:
    import nixpkgsInput {
      inherit system;
      config.allowUnfree = true;
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
  };
}
