{
  description = "My computer setup";

  inputs = {
    # ─── Infrastructure ─────────────────────────────────────────────────────────
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # ─── Apps are managed by Homebrew (Brewfile at repo root) ──────────────────
    # pi, claude-code, herdr, aerospace, and general CLI apps live in Brewfile.
    # Nix handles home config (zsh/tmux/editor) + nix-integrated tooling only.
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
