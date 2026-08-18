{ config, inputs, lib, ... }:
let
  boolString = value: if value then "true" else "false";
in {
  perSystem = { pkgs, system, ... }:
    let
      darwinHomeConfiguration = config.flake.homeConfigurations.ianluo;
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
            test "${darwinHomeConfiguration.config.home.username}" = "ianluo"
            test "${darwinHomeConfiguration.config.home.homeDirectory}" = "/Users/ianluo"
            test "${darwinHomeConfiguration.config.home.stateVersion}" = "${config.repo.stateVersion}"
            test "${darwinHomeConfiguration.config.home.sessionVariables.EDITOR}" = "vi"
            test "${boolString darwinHomeConfiguration.config.launchd.agents.nix-gc.enable}" = "true"
            test "${boolString (darwinHomeConfiguration.config.xdg.configFile."aerospace/aerospace.toml".text != "")}" = "true"
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
