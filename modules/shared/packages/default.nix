{ pkgs, lib, stdenv, unstable-pkgs ? pkgs, system ? pkgs.stdenv.hostPlatform.system, customPackageDefinitions ? { } }:
let
  customPackages = import ./custom {
    inherit pkgs;
    definitions = customPackageDefinitions;
  };

  stablePackages = import ./stable.nix {
    inherit pkgs lib;
    inherit customPackages;
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

  inherit stablePackages unstablePackages darwinPackages customPackages;
}
