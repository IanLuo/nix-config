{
  pkgs,
  lib,
  system ? "aarch64-darwin",
  ...
}:
{
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
}
