{ inputs, ... }:
# LLM agent CLIs — curated list, sourced from numtide/llm-agents.nix
# (daily-updated packages, prebuilt binaries on cache.numtide.com).
# No nixpkgs follows: we get their CI-tested combo + binary cache.
{
  flake.modules.homeManager.llm-agents-packages = { pkgs, lib, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      agents = inputs.llm-agents.packages.${system};
    in {
      home.packages = [
        agents.pi
        agents.herdr
        agents.claude-code
        agents.antigravity-cli
      ];
    };
}
