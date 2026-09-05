{ ... }:
{
  # NixOS variant only — the macOS (nix-darwin) variant was removed.
  # On macOS, flake-level nix settings (substituters, fallback) live in
  # modules/system/nix-cache.nix (flake.nixConfig); the daemon config is managed by
  # Determinate Nix (/etc/nix/nix.conf + /etc/nix/nix.custom.conf).
  flake.modules.nixos.system-foundation = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
