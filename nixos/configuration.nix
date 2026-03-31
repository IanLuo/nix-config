{ ... }:
{
  # This repository is now organized around flake-parts aspect modules.
  # Use `nixos-rebuild switch --flake .#nixos-vm` to apply the full system.
  # Hardware configuration is at modules/hosts/_nixos-vm/hardware-configuration.nix
  system.stateVersion = "24.11";
}
