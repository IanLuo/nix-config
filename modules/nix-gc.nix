{ ... }:
# Weekly nix garbage collection — macOS launchd agent (was nix-darwin's nix.gc).
# Imported by the darwin host.
{
  flake.modules.homeManager.nix-gc = { pkgs, ... }: {
    launchd.agents.nix-gc = {
      enable = true;
      config = {
        Label = "home-manager.nix-gc";
        ProgramArguments = [ "${pkgs.nix}/bin/nix-collect-garbage" "--delete-older-than" "30d" ];
        StartCalendarInterval = {
          Weekday = 0;
          Hour = 2;
          Minute = 0;
        };
      };
    };
  };
}
