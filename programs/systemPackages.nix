{
stdenv
, pkgs
, lib
} : 
let
darwinPackages = with pkgs; [ 
    m-cli 
    iterm2
    discord
    raycast
    cocoapods
  ];

normalPackages = with pkgs; [
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
    sketchybar-app-font
    manix
];
  
packages = normalPackages ++ lib.optionals stdenv.isDarwin darwinPackages; 
in {
  inherit packages;
}
