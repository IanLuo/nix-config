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
    dbeaver-bin
    element-desktop
    fd
    ripgrep
    podman
    nerdfonts 
    # kitty
    zsh
    nnn
    nixd
    sketchybar-app-font
    manix
    podman
    nix-index
];
  
packages = normalPackages ++ lib.optionals stdenv.isDarwin darwinPackages; 
in {
  inherit packages;
}
