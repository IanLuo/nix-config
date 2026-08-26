{ ... }:
# LLM agent CLIs — curated separately so this group is managed as its own
# list (fast-moving; update via nixpkgs-unstable or per-app inputs later).
# Same source as unstable-packages: the homeConfiguration pkgs (nixpkgs-unstable).
{
  flake.modules.homeManager.llm-agents-packages = { pkgs, lib, ... }:
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
        ];
    };
}
