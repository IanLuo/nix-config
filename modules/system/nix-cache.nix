{ ... }:
# Flake-level nix settings — binary caches beyond cache.nixos.org.
# Declared here (not in flake.nix) so the input manifest stays about inputs.
#
# ⚠️ INERT on hosts where the user is not a nix trusted user (the default:
# `trusted-users = root`). `substituters` is a *restricted* setting, so the
# daemon silently ignores the client-supplied values below — no warning,
# no effect. The authoritative substituter config is the daemon's own file:
#   /etc/nix/nix.custom.conf  (site-specific, root-owned; mirrors + these
#   caches + their public keys)
# Keep the keys below in sync with that file. Verify with:
#   nix config show | grep -E '^(substituters|trusted-public-keys)'
#   nix build --dry-run … # a cached pkg must be *fetched*, not *built*
#   - cache.numtide.com: prebuilt llm-agents packages
#     (github:numtide/llm-agents.nix — see modules/packages/llm-agents-packages.nix).
#   - nix-community.cachix.org: general nix-community project cache.
{
  flake.nixConfig = {
    # Build from source if a substitute download fails (default is false).
    fallback = true;

    extra-substituters = [
      "https://cache.numtide.com"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
