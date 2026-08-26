{ ... }:
# Flake-level nix settings — binary caches beyond cache.nixos.org.
# Declared here (not in flake.nix) so the input manifest stays about inputs.
# Currently: Numtide's cache, which serves the prebuilt llm-agents packages
# (github:numtide/llm-agents.nix — see modules/llm-agents-packages.nix).
{
  flake.nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };
}
