{ ... }:
# Unstable channel (nixpkgs) packages — fast-moving apps that need freshness
# (several are not in 25.05) + the nix-ecosystem tooling.
{
  flake.modules.homeManager.unstable-packages = { pkgs, lib, ... }:
    # pkgs = homeConfiguration pkgs = nixpkgs-unstable (repo.nix mkPkgs)
    let
      unstablePkgs = pkgs;
    in {
      home.packages =
        with unstablePkgs; [
          uv
          bun
          # terminal file manager — replaces nnn (maintenance mode)
          yazi
          # terminal emulators
          kitty
          alacritty
          # ghostty: not here — the source-built pkg is Linux-only in nixpkgs;
          # macOS uses ghostty-bin via modules/programs/ghostty.nix
          # fonts (single-family — downloads only the FiraCode archive)
          nerd-fonts.fira-code
          # nix-ecosystem tooling
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
