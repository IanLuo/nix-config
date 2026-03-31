{ config, ... }:
{
  flake.modules.homeManager.system-packages = { pkgs, ... }: {
    home.packages = (config.repo.mkSystemPackages pkgs.stdenv.hostPlatform.system).packages;
  };
}
