{ config, inputs, ... }:
let
  system = "aarch64-darwin";
  user = "ianluo";
in {
  flake.homeConfigurations.ianluo = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = config.repo.mkPkgs system;
    modules = [
      config.flake.modules.homeManager.base
      config.flake.modules.homeManager.stable-packages
      config.flake.modules.homeManager.unstable-packages
      config.flake.modules.homeManager.llm-agents-packages
      config.flake.modules.homeManager.herdr
      config.flake.modules.homeManager.cli
      config.flake.modules.homeManager.shell
      config.flake.modules.homeManager.tmux
      config.flake.modules.homeManager.editor
      config.flake.modules.homeManager.aerospace
      config.flake.modules.homeManager.kitty
      config.flake.modules.homeManager.alacritty
      config.flake.modules.homeManager.nix-gc
      config.flake.modules.homeManager.macos-defaults
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

        # allowUnfree comes from config.repo.mkPkgs (modules/system/repo.nix).

        # Standard ~/.config layout (aerospace, git, nvim, tmux ...)
        xdg.enable = true;

        home.username = user;
        home.homeDirectory = "/Users/${user}";
      }
    ];
  };
}
