{
  pkgs,
  lib,
  system ? "aarch64-darwin",
  ...
}:
let
  # Helper to fetch a package from a specific nixpkgs commit
  fetchNixpkgsPackage = { commit, package }: 
    let
      nixpkgs-commit = import (builtins.fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/${commit}.tar.gz";
      }) { inherit system; config.allowUnfree = true; };
    in nixpkgs-commit.${package};

  # Helper to build a package directly from git
  buildFromGit = {
    owner,
    repo, 
    rev,
    sha256,
    pname,
    version ? "git-${builtins.substring 0 7 rev}",
    buildInputs ? [],
    nativeBuildInputs ? [],
    buildPhase ? null,
    installPhase ? null,
    ...
  }@args:
    pkgs.stdenv.mkDerivation (args // {
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev sha256;
      };
      inherit pname version buildInputs nativeBuildInputs;
    } // lib.optionalAttrs (buildPhase != null) { inherit buildPhase; }
      // lib.optionalAttrs (installPhase != null) { inherit installPhase; });

  # BLEEDING-EDGE PACKAGES CONFIGURATION
  # Add your bleeding-edge packages here
  bleedingPackages = {
    # EXAMPLE 1: Get latest Deno from nixpkgs master
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
  
  # Export helpers for other modules
  inherit fetchNixpkgsPackage buildFromGit;
}
