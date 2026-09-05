{ inputs, lib, ... }:
let
  mkPkgsFrom = nixpkgsInput: system:
    import nixpkgsInput {
      inherit system;
      config.allowUnfree = true;
    };
in {
  # Shared repo-level values (read via config.repo.* from modules/hosts).
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

    # Base/home pkgs (nixpkgs-unstable). packages/stable-packages.nix imports
    # the nixpkgs (25.05) input directly — no helper needed for it.
    mkPkgs = mkPkgsFrom inputs.nixpkgs-unstable;
  };
}
