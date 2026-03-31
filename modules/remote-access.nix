{
  flake.modules.nixos.remote-access = {
    services.openssh.enable = true;
    networking.firewall.enable = false;
  };
}
