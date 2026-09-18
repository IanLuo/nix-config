{ config, inputs, ... }:
let
  system = "aarch64-darwin";
  user = "iluo";
  darwinModules = import ./_darwin-modules.nix { inherit config; };
  stablePkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in {
  flake.homeConfigurations.iluo = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = config.repo.mkPkgs system;
    modules = darwinModules ++ [
      {
        assertions = [
          {
            assertion = user != "";
            message = "Home Manager user must not be empty.";
          }
          {
            assertion = builtins.match "/Users/.*" "/Users/${user}" != null;
            message = "Darwin home directory must stay under /Users.";
          }
        ];

        xdg.enable = true;

        home.username = user;
        home.homeDirectory = "/Users/${user}";

        home.packages = with stablePkgs; [ nodejs azure-cli ];

        custom.safeAreaTop = 32;
      }
    ];
  };
}
