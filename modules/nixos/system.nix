{ config, pkgs, user ? "ian", ... }:
{
  assertions = [
    {
      assertion = user != "";
      message = "NixOS user must not be empty.";
    }
    {
      assertion = builtins.elem "wheel" config.users.users.${user}.extraGroups;
      message = "NixOS user must keep wheel access.";
    }
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      firefox
      tree
      neovim
      git
    ];
  };

  services.openssh.enable = true;
  networking.firewall.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
