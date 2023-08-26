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
  ] ++ optionals stdenv.isDarwin [ 
    m-cli 
    iterm2
    discord
    raycast
  ];
}
