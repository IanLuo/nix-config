{ ... }:
# Flake-level nix settings — binary caches beyond cache.nixos.org.
# Declared here (not in flake.nix) so the input manifest stays about inputs.
# Single source of truth for substituters: cache.nixos.org is the implicit
# default; the two below are added via extra-substituters.
#   - cache.numtide.com: prebuilt llm-agents packages
#     (github:numtide/llm-agents.nix — see modules/llm-agents-packages.nix).
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
