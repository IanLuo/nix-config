{ ... }:
{
  # NixOS variant only — the macOS (nix-darwin) variant was removed.
  # On macOS, aerospace is installed via brew cask and configured by
  # home-manager (modules/hosts/ianluo.nix → ~/.config/aerospace/aerospace.toml).
  flake.modules.nixos.window-management = { pkgs, ... }: {
    services.xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
          i3blocks
        ];
      };
    };

    services.displayManager.defaultSession = "xfce+i3";
  };
}
