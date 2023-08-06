{ pkgs, lib, user, inputs, ... }:
{
  users.users.${user}.home = "/Users/${user}";

  imports = [
    ./home-manager 
    ../services
  ];

  # make sure the nix daemon is always runs
  services.nix-daemon.enable = true;
} 
