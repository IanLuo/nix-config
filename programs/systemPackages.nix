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
];
  
packages = normalPackages ++ lib.optionals stdenv.isDarwin darwinPackages; 
in {
  packages = builtins.trace ">>${lib.concatStrings packages}" packages;
}
