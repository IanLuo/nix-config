{ config, inputs, ... }:
let
  topConfig = config;
  system = "aarch64-darwin";
  user = "ianluo";
in {
  flake.modules.darwin.ianluo = {
    assertions = [
      {
        assertion = user != "";
        message = "Darwin user must not be empty.";
      }
      {
        assertion = builtins.match "/Users/.*" "/Users/${user}" != null;
        message = "Darwin home path must stay under /Users.";
      }
    ];

    imports = with topConfig.flake.modules.darwin; [
      system-foundation
      window-management
    ];

    users.users.${user}.home = "/Users/${user}";
    system.primaryUser = user;
    system.stateVersion = 6;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
    home-manager.users.${user} = {
      imports = [
        topConfig.flake.modules.homeManager.base
        topConfig.flake.modules.homeManager.system-packages
        topConfig.flake.modules.homeManager.cli
        topConfig.flake.modules.homeManager.shell
        topConfig.flake.modules.homeManager.tmux
        topConfig.flake.modules.homeManager.editor
        topConfig.flake.modules.homeManager."ai-home"
      ];

      home.username = user;
      home.homeDirectory = "/Users/${user}";

      programs.aiHome.enable = true;
      programs.aiHome.sources.gstack = {
        enable = true;
        package = topConfig.repo.mkGstack (topConfig.repo.mkUnstablePkgs system);
      };
    };
  };

  flake.darwinConfigurations.ianluo = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      unstable-pkgs = topConfig.repo.mkUnstablePkgs system;
      repo = topConfig.repo;
    };
    modules = [
      topConfig.flake.modules.darwin.ianluo
      inputs.home-manager.darwinModules.home-manager
    ];
  };
}
