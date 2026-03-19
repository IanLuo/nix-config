{ inputs, stateVersion, systemPackages, unstable-pkgs, user, ... }:
{
  imports = [
    ../../modules/nixos/system.nix
  ];

  system.stateVersion = "24.11";

  home-manager.users.${user} = import ../../modules/linux/home.nix;
  home-manager.extraSpecialArgs = {
    inherit inputs stateVersion systemPackages unstable-pkgs user;
  };
}
