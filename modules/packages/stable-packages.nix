{ inputs, ... }:
# Stable channel (nixpkgs 25.05) packages — mature, slow-moving apps.
# Fast-moving apps live in packages/unstable-packages.nix.
{
  flake.modules.homeManager.stable-packages = { pkgs, lib, ... }:
    # pkgs = homeConfiguration pkgs (nixpkgs-unstable) — used only for system.
    # stablePkgs = the nixpkgs 25.05 input, imported directly below.
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
          mosh
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ m-cli ];
    };
}
