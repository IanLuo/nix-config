{ stateVersion, systemPackages, ... }:
{
  assertions = [
    {
      assertion = stateVersion != "";
      message = "Home Manager stateVersion must not be empty.";
    }
    {
      assertion = systemPackages ? packages;
      message = "systemPackages must provide a packages attribute.";
    }
  ];

  imports = [
    ./home/programs.nix
  ];

  home.stateVersion = stateVersion;
  home.packages = systemPackages.packages;

  home.sessionVariables = {
    EDITOR = "vi";
  };
}
