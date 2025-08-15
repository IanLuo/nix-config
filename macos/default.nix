{ pkgs, lib, user, inputs, systemPackages, ... }:
{
  users.users.${user}.home = "/Users/${user}";

  imports = [
    ./home-manager 
    ../services/mac.nix
    # ../programs/sketchybar
  ];

  system.primaryUser=user;

  # Nix performance optimizations
  nix = {
    enable = false;
    settings = {
      # Use all available cores for building
      cores = 10;  # Your M1 Pro has 10 cores
      max-jobs = "auto";
      
      # Additional substituters for faster downloads
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://numtide.cachix.org"
      ];
      
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy2Aw8GPfVZ9YLaTuMQ8/t5Yf0qWg="
      ];
      
      # Improve build performance
      builders-use-substitutes = true;
      fallback = true;
      
      # Experimental features for better performance
      experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
    };
    
    # Enable garbage collection
    gc = {
      # automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; }; # Sunday 2 AM
      options = "--delete-older-than 30d";
    };
    
    # Optimize store automatically
    # optimise.automatic = true;
  };

} 
