{
  description = "My computer setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    bun2nix.url = "github:nix-community/bun2nix";

    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    opencode.url = "github:anomalyco/opencode";
    gstack-src = {
      url = "github:garrytan/gstack/7ea6ead9fa88ba439002a6dc1d7409649b45e9f5";
      flake = false;
    };
    specify-cli-src = {
      url = "github:github/spec-kit/v0.3.2";
      flake = false;
    };
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
