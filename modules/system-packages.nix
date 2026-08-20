{ ... }:
# Nix-installed packages (the small set that must stay in nix — nix-ecosystem
# tooling). General apps live in the Brewfile; everything else is installed
# by home-manager program modules (see cli.nix/shell.nix/tmux.nix/editor.nix).
{
  flake.modules.homeManager.system-packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      nix-direnv
      any-nix-shell
      manix
      nix-prefetch-git
      nixd
      nix-index
      nix-tree
      nix-du
    ];
  };
}
