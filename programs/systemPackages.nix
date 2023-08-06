{
stdenv
, pkgs
, lib
} : with pkgs // lib; {
  packages = [
    git
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
    iterm2
    element-desktop
    discord
    fd
    raycast
    ripgrep
    docker
    podman
    lorri
    nerdfonts 
  ] ++ optionals stdenv.isDarwin [ m-cli ];
}
