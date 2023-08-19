{
stdenv
, pkgs
, lib
} : with pkgs // lib; {
  packages = [
    git
    gcc
    direnv
    curl
    wget
    zsh
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
    lorri
    nerdfonts 
  ] ++ optionals stdenv.isDarwin [ 
    m-cli 
    iterm2
    discord
    raycast
  ];
}
