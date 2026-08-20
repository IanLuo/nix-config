{ inputs, ... }:
# Stable channel (nixpkgs 25.05) packages — mature, slow-moving apps.
# Fast-moving apps live in unstable-packages.nix; config in the other modules.
{
  flake.modules.homeManager.stable-packages = { pkgs, lib, ... }:
    let
      stablePkgs = import inputs.nixpkgs {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    in {
      home.packages =
        with stablePkgs; [
          gh
          wget
          tree
          direnv
          graphviz
          gcc
          curl
          ripgrep
          fd
          podman
          nnn
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [ m-cli ];
    };
}
