{ pkgs, lib, user, inputs, systemPackages, ... }:
{
  users.users.${user}.home = "/Users/${user}";

  imports = [
    ./home-manager 
    ../services/mac.nix
    # ../programs/sketchybar
  ];

  # make sure the nix daemon is always runs
  services.nix-daemon.enable = true;

} 
