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

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';


} 
