{ config, ... }:
{
  flake.modules.homeManager.base = {
    assertions = [
      {
        assertion = config.repo.stateVersion != "";
        message = "Home Manager stateVersion must not be empty.";
      }
    ];

    home.stateVersion = config.repo.stateVersion;

    home.sessionVariables = {
      EDITOR = "vi";
    };
  };
}
