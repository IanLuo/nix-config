{ inputs, ... }:
# In-house tools — observe, fs, memstore — installed from their own GitHub
# flakes (flake.lock pins each commit). No nixpkgs follows: each flake pins the
# nixpkgs its build was tested against.
#
# cap is not here: modules/programs/cap.nix imports its module, which also
# wires the launchd service.
{
  flake.modules.homeManager.ianluo-tools-packages = { pkgs, ... }:
    let system = pkgs.stdenv.hostPlatform.system;
    in {
      home.packages = [
        inputs.observe.packages.${system}.default
        inputs.fs.packages.${system}.default
        inputs.memstore.packages.${system}.default
      ];
    };
}
