{ ... }:
# Unstable channel (nixpkgs) packages — fast-moving apps that need freshness
# (several are not in 25.05) + the nix-ecosystem tooling.
{
  flake.modules.homeManager.unstable-packages = { pkgs, lib, ... }:
    # pkgs = homeConfiguration pkgs = nixpkgs-unstable (repo.nix mkPkgs)
    let
      unstablePkgs = pkgs;
    in {
      home.packages =
        with unstablePkgs; [
        pi-coding-agent
        herdr
        claude-code
        antigravity-cli # gemini-cli → antigravity (gemini deprecated upstream)
        uv
        bun
        # nix-ecosystem tooling
        nix-direnv
        any-nix-shell
        manix
        nix-prefetch-git
        nixd
        nix-index
        nix-tree
        nix-du
      ];
  };
}
