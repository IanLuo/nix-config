{ inputs, stateVersion, systemPackages, user, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = {
    inherit inputs stateVersion systemPackages user;
  };

  home-manager.users.${user} = { pkgs, ... }: {
    imports = [
      ../shared/home.nix
    ];

    home.packages = [
      inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.sessionVariables = {
      GEMINI_API_KEY = "";
    };
  };
}
