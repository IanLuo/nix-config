{ home-manager, mkPkgs, mkSpecialArgs, stateVersion, darwinConfiguration, linuxHomeConfiguration, nixosConfiguration, ... }:
let
  darwinPkgs = mkPkgs "aarch64-darwin";
  linuxPkgs = mkPkgs "aarch64-linux";

  boolString = value: if value then "true" else "false";

  mkCheck = pkgs: name: script:
    pkgs.runCommand name { } script;
in {
  aarch64-darwin = {
    darwin-invariants = mkCheck darwinPkgs "darwin-invariants" ''
      test "${darwinConfiguration.config.system.primaryUser}" = "ianluo"
      test "${boolString darwinConfiguration.config.services.skhd.enable}" = "true"
      test "${boolString darwinConfiguration.config.services.yabai.enable}" = "true"
      test "${darwinConfiguration.config.home-manager.users.ianluo.home.stateVersion}" = "${stateVersion}"
      test "${darwinConfiguration.config.home-manager.users.ianluo.home.sessionVariables.EDITOR}" = "vi"
      touch "$out"
    '';

    linux-home-invariants = mkCheck darwinPkgs "linux-home-invariants" ''
      test "${linuxHomeConfiguration.config.home.username}" = "ian-linux-dev"
      test "${linuxHomeConfiguration.config.home.homeDirectory}" = "/home/ian-linux-dev"
      test "${linuxHomeConfiguration.config.home.stateVersion}" = "${stateVersion}"
      touch "$out"
    '';

    nixos-invariants = mkCheck darwinPkgs "nixos-invariants" ''
      test "${boolString nixosConfiguration.config.services.openssh.enable}" = "true"
      test "${boolString nixosConfiguration.config.networking.firewall.enable}" = "false"
      test "${nixosConfiguration.config.services.displayManager.defaultSession}" = "xfce+i3"
      test "${nixosConfiguration.config.home-manager.users.ian.home.homeDirectory}" = "/home/ian"
      touch "$out"
    '';
  };

  aarch64-linux = {
    nixos-vm-smoke = linuxPkgs.testers.runNixOSTest {
      name = "nixos-vm-smoke";

      nodes.machine = { ... }: {
        imports = [
          ../hosts/nixos/nixos-vm.nix
          home-manager.nixosModules.home-manager
        ];

        _module.args = mkSpecialArgs {
          system = "aarch64-linux";
          user = "ian";
        };

        virtualisation.memorySize = 1024;
        virtualisation.diskSize = 4096;
      };

      testScript = ''
        start_all()
        machine.wait_for_unit("multi-user.target")
        machine.succeed("id ian")
        machine.succeed("test -d /home/ian")
        machine.succeed("systemctl is-active sshd.service")
      '';
    };
  };
}
