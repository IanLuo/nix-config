{
  description = "My computer setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    , nix-doom-emacs
    , ...
    }:
    let
      myMacs = [ "CDU-L737HCJ9FJ" "ianluo" ];
      mySystem = "aarch64-darwin";
      pkgs = import nixpkgs {
        system = mySystem;
        config.allowUnfree = true;
      };
    in
    with pkgs; {
      fonts.fonts = [ fira-code ];
      darwinConfigurations = lib.attrsets.genAttrs myMacs (user:
        darwin.lib.darwinSystem {
          inherit pkgs;
          system = mySystem;
          modules = [
            home-manager.darwinModules.home-manager
            ./macos/default.nix
          ];
        });
    };
}
