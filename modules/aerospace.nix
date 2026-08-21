{ ... }:
# AeroSpace window manager (macOS only — imported by the darwin host).
# home-manager's programs.aerospace module renders the config and manages the
# launchd agent with the correct nix-store package path.
{
  flake.modules.homeManager.aerospace = { pkgs, ... }: {
    programs.aerospace = {
      enable = true;
      package = pkgs.aerospace; # from nixpkgs-unstable (see unstable-packages.nix)
      launchd.enable = true;    # home-manager owns the launchd agent

      settings = {
        # config-version 2 (aerospace 0.2x): persistent-workspaces must be
        # explicit — v1 inferred it from bindings (all 10 here), v2 default
        # is empty. Declared explicitly to preserve behavior.
        "config-version" = 2;
        persistent-workspaces = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ];

        gaps = {
          outer = {
            left = 8;
            bottom = 8;
            top = 8;
            right = 8;
          };
        };

        mode.main.binding = {
          # Window focus (vim-style)
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          # Window movement
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          # Window management
          alt-q = "close";
          alt-f = "fullscreen";
          alt-g = "layout floating tiling";

          # Layout switching
          alt-comma = "layout accordion horizontal vertical";
          alt-period = "layout tiles horizontal vertical";

          # Resize
          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";

          # Workspace switching (1-10)
          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";
          alt-8 = "workspace 8";
          alt-9 = "workspace 9";
          alt-0 = "workspace 10";

          # Move window to workspace
          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";
          alt-shift-0 = "move-node-to-workspace 10";

          # Workspace navigation
          alt-tab = "workspace-back-and-forth";
          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
        };
      };
    };
  };
}
