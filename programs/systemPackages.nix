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
  ] ++ optionals stdenv.isDarwin [ 
    m-cli 
    iterm2
    discord
    raycast
  ];
}
