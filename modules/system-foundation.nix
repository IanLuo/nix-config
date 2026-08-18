{ ... }:
{
  # NixOS variant only — the macOS (nix-darwin) variant was removed.
  # On macOS, nix daemon settings live in ./nix.conf (applied by scripts/setup.sh).
  flake.modules.nixos.system-foundation = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
