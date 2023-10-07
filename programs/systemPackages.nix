{
stdenv
, pkgs
, lib
} : with pkgs // lib; {
  packages = [
    git
    gcc
    curl
    direnv
    nix-direnv
    wget
    tree
    any-nix-shell
    tmate
    tmux
    nodejs
    dbeaver
    element-desktop
    fd
    ripgrep
    docker
    podman
    nerdfonts 
    kitty
    zsh
    nnn
    nixd
  ] ++ optionals stdenv.isDarwin [ 
    m-cli 
    iterm2
    discord
    raycast
  ];
}
