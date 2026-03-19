{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/nixos/system.nix
  ];

  system.stateVersion = "24.11";
}
