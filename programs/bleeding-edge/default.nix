{
  pkgs,
  lib,
  system ? "aarch64-darwin",
  ...
}:
let
  # Import helper functions
  helpers = import ./helpers.nix { inherit pkgs lib system; };
  inherit (helpers) fetchNixpkgsPackage buildFromGit;

  # BLEEDING-EDGE PACKAGES CONFIGURATION
  # Add your bleeding-edge packages here
  bleedingPackages = {
    # NOTE: gemini-cli is now available in nixpkgs-unstable, moved to unstablePackages
    # Uncomment and modify as needed:
    # deno-latest = fetchNixpkgsPackage {
    #   commit = "master";  # Use "master" or specific commit hash
    #   package = "deno";
    # };

    # EXAMPLE 2: Build a Go CLI tool directly from git
    # Uncomment and replace with your tool:
    # my-go-tool = buildFromGit {
    #   owner = "cli";
    #   repo = "cli";
    #   rev = "v2.40.1";  # or "main" or specific commit
    #   sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # Replace with real hash
    #
    #   pname = "gh";
    #   version = "2.40.1-bleeding";
    #
    #   nativeBuildInputs = with pkgs; [ go ];
    #
    #   buildPhase = ''
    #     export HOME=$TMPDIR
    #     make build
    #   '';
    #
    #   installPhase = ''
    #     make install prefix=$out
    #   '';
    # };

    # EXAMPLE 3: Get a Rust tool from git
    # my-rust-tool = buildFromGit {
    #   owner = "BurntSushi";
    #   repo = "ripgrep";
    #   rev = "main";
    #   sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    #
    #   pname = "ripgrep-bleeding";
    #
    #   nativeBuildInputs = with pkgs; [ rustc cargo ];
    #
    #   buildPhase = ''
    #     cargo build --release
    #   '';
    #
    #   installPhase = ''
    #     mkdir -p $out/bin
    #     cp target/release/rg $out/bin/
    #   '';
    # };

    # EXAMPLE 4: Get package from a specific nixpkgs PR (before merge)
    # experimental-tool = let
    #   nixpkgs-pr = import (builtins.fetchTarball {
    #     url = "https://github.com/nixos/nixpkgs/archive/pull/123456/head.tar.gz";
    #   }) { inherit system; config.allowUnfree = true; };
    # in nixpkgs-pr.experimental-tool;
  };

  # Filter out null/disabled packages
  enabledPackages = lib.attrsets.filterAttrs (_: pkg: pkg != null) bleedingPackages;

in {
  # Export packages list for systemPackages
  packages = lib.attrsets.attrValues enabledPackages;

  # Export individual packages for selective use
  inherit enabledPackages;

  # Re-export helpers for other modules
  inherit (helpers) fetchNixpkgsPackage buildFromGit;
}
