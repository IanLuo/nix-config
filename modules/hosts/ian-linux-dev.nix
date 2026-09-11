{ config, inputs, ... }:
let
  system = "aarch64-linux";
  user = "ian-linux-dev";
in {
  flake.homeConfigurations.ian-linux-dev = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = config.repo.mkPkgs system;
    modules = [
      config.flake.modules.homeManager.base
      config.flake.modules.homeManager.stable-packages
        config.flake.modules.homeManager.unstable-packages
      config.flake.modules.homeManager.llm-agents-packages
      config.flake.modules.homeManager.pi-harness
      config.flake.modules.homeManager.herdr
      config.flake.modules.homeManager.cli
      config.flake.modules.homeManager.shell
      config.flake.modules.homeManager.editor
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

      }
    ];
  };
}
