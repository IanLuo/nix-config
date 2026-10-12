{ ... }:
# Ollama — local LLM runner (llama.cpp/Metal backend, OpenAI-compatible
# API on 127.0.0.1:11434).
#
# Package comes from nixpkgs-unstable (fast-moving; model support tracks
# ollama releases). The launchd agent keeps `ollama serve` running at
# login and restarts it if it dies (KeepAlive), same pattern as nix-gc.
{
  flake.modules.homeManager.ollama = { pkgs, ... }: {
    home.packages = [ pkgs.ollama ];

    launchd.agents.ollama = {
      enable = true;
      config = {
        Label = "home-manager.ollama";
        ProgramArguments = [ "${pkgs.ollama}/bin/ollama" "serve" ];
        EnvironmentVariables = {
          # Bind to loopback only — pi reaches it via localhost:11434/v1.
          OLLAMA_HOST = "127.0.0.1:11434";
        };
        KeepAlive = true;
      };
    };
  };
}