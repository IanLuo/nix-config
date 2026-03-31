{
  flake.modules.darwin.system-foundation = {
    nix = {
      enable = false;
      settings = {
        cores = 10;
        max-jobs = "auto";

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

        builders-use-substitutes = true;
        fallback = true;
        experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
      };

      gc = {
        interval = { Weekday = 0; Hour = 2; Minute = 0; };
        options = "--delete-older-than 30d";
      };
    };
  };

  flake.modules.nixos.system-foundation = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
