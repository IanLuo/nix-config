{ pkgs, lib, stdenv, unstable-pkgs ? pkgs, system ? pkgs.stdenv.hostPlatform.system, customPackageDefinitions ? { } }:
let
  customPackages = import ./custom {
    inherit pkgs unstable-pkgs;
    definitions = customPackageDefinitions;
  };

  stablePackages = import ./stable.nix {
    inherit pkgs lib;
    inherit customPackages;
  };

  unstablePackages = import ./unstable.nix {
    inherit unstable-pkgs;
  };

  darwinPackages = import ./darwin.nix {
    inherit pkgs unstable-pkgs;
  };
in {
  packages =
    stablePackages
    ++ unstablePackages
    ++ lib.optionals stdenv.isDarwin darwinPackages
    ++ lib.attrValues customPackages;

  inherit stablePackages unstablePackages darwinPackages customPackages;
}
