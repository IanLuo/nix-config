{ pkgs, unstable-pkgs, ... }:
(with pkgs; [
  m-cli
]) ++ (with unstable-pkgs; [
])
