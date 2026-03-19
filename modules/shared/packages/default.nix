{ pkgs, lib, stdenv, unstable-pkgs ? pkgs, system ? pkgs.stdenv.hostPlatform.system }:
let
  stablePackages = import ./stable.nix {
    inherit pkgs lib;
  };

  unstablePackages = import ./unstable.nix {
    inherit unstable-pkgs;
  };

  darwinPackages = import ../../darwin/packages.nix {
    inherit pkgs unstable-pkgs;
  };

  bleedingEdge = import ../../../programs/bleeding-edge {
    inherit pkgs lib system;
  };
in {
  packages =
    stablePackages
    ++ unstablePackages
    ++ lib.optionals stdenv.isDarwin darwinPackages
    ++ bleedingEdge.packages;

  inherit stablePackages unstablePackages darwinPackages;
}
