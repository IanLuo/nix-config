{ config, inputs, lib, ... }:
let
  boolString = value: if value then "true" else "false";
in {
  perSystem = { pkgs, system, ... }:
    let
      darwinConfiguration = config.flake.darwinConfigurations.ianluo;
      linuxHomeConfiguration = config.flake.homeConfigurations.ian-linux-dev;
      nixosConfiguration = config.flake.nixosConfigurations.nixos-vm;

      mkCheck = name: script:
        pkgs.runCommand name { } script;
    in
    lib.mkMerge [
      {
        formatter = pkgs.nixpkgs-fmt;
      }

      (lib.optionalAttrs (system == "aarch64-darwin") {
        checks = {
          darwin-invariants = mkCheck "darwin-invariants" ''
            test "${darwinConfiguration.config.system.primaryUser}" = "ianluo"
            test "${boolString darwinConfiguration.config.services.skhd.enable}" = "true"
            test "${boolString darwinConfiguration.config.services.yabai.enable}" = "true"
            test "${darwinConfiguration.config.home-manager.users.ianluo.home.stateVersion}" = "${config.repo.stateVersion}"
            test "${darwinConfiguration.config.home-manager.users.ianluo.home.sessionVariables.EDITOR}" = "vi"
            touch "$out"
          '';

          linux-home-invariants = mkCheck "linux-home-invariants" ''
            test "${linuxHomeConfiguration.config.home.username}" = "ian-linux-dev"
            test "${linuxHomeConfiguration.config.home.homeDirectory}" = "/home/ian-linux-dev"
            test "${linuxHomeConfiguration.config.home.stateVersion}" = "${config.repo.stateVersion}"
            touch "$out"
          '';

          nixos-invariants = mkCheck "nixos-invariants" ''
            test "${boolString nixosConfiguration.config.services.openssh.enable}" = "true"
            test "${boolString nixosConfiguration.config.networking.firewall.enable}" = "false"
            test "${nixosConfiguration.config.services.displayManager.defaultSession}" = "xfce+i3"
            test "${nixosConfiguration.config.home-manager.users.ian.home.homeDirectory}" = "/home/ian"
            touch "$out"
          '';
        };
      })

      (lib.optionalAttrs (system == "aarch64-linux") {
        checks = {
          nixos-vm-smoke = pkgs.testers.runNixOSTest {
            name = "nixos-vm-smoke";

            nodes.machine = { ... }: {
              imports = [
                config.flake.modules.nixos.nixos-vm-base
                inputs.home-manager.nixosModules.home-manager
              ];

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
      })
    ];
}
