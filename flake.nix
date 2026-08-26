{
  description = "My computer setup";

  inputs = {
    # ─── Infrastructure ─────────────────────────────────────────────────────────
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05"; # stable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # LLM agent CLIs (daily-updated packages + prebuilt binaries).
    # No follows: llm-agents pins its own nixpkgs-unstable (CI-tested combo +
    # Numtide binary cache). See modules/llm-agents-packages.nix.
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  # Numtide binary cache for llm-agents packages (from their README).
  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
      ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
      ];
    };
}
