{ config, inputs, ... }:
let
  system = "aarch64-linux";
  user = "ian-linux-dev";
in {
  flake.homeConfigurations.ian-linux-dev = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = config.repo.mkPkgs system;
    modules = [
      config.flake.modules.homeManager.base
      config.flake.modules.homeManager.system-packages
      config.flake.modules.homeManager.cli
      config.flake.modules.homeManager.shell
      config.flake.modules.homeManager.tmux
      config.flake.modules.homeManager.editor
      config.flake.modules.homeManager."ai-home"
      {
        assertions = [
          {
            assertion = user != "";
            message = "Home Manager user must not be empty.";
          }
          {
            assertion = builtins.match "/home/.*" "/home/${user}" != null;
            message = "Linux home directory must stay under /home.";
          }
        ];

        home.username = user;
        home.homeDirectory = "/home/${user}";

        programs.aiHome = {
          enable = true;
          sources.gstack.package = config.repo.mkGstack (config.repo.mkPkgs system);
        };
      }
    ];
  };
}
