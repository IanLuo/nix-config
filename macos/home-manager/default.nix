{ pkgs
, lib
, inputs
, stateVersion 
, user
, systemPackages
, ... 
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${user} = { pkgs, ... }:
  {

    home.stateVersion = stateVersion; 
    home.packages = systemPackages.packages;

    imports = (import ../../programs).packages 
      ++ [ 
        inputs.nix-doom-emacs.hmModule 
        ../../programs/others.nix
      ];
  };
}
