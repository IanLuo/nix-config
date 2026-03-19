{ ... }:
{
  imports = [
    ../../modules/darwin/system.nix
    ../../modules/darwin/home-manager.nix
  ];

  system.stateVersion = 6;
}
