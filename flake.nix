{
  description = "My computer setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Emacs
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = inputs@{ self, ... }:
    let
      myUsers = [ "CDU-L737HCJ9FJ" "ianluo" ];
      myDarwin = "aarch64-darwin";
      myFonts = [ "fira-code" ];
      stateVersion = "23.05";
      pkgs = import inputs.nixpkgs {
        system = myDarwin;
        config.allowUnfree = true;
      };
    in {
      darwinConfigurations = pkgs.lib.attrsets.genAttrs myUsers (user:
        inputs.darwin.lib.darwinSystem {
          inherit pkgs;
          
          system = myDarwin;
          modules = [
            inputs.home-manager.darwinModules.home-manager
            ./macos 
            ./misc/fonts.nix
          ];
          specialArgs = { inherit inputs stateVersion user; };
        });
    };
}
