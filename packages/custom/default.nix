{ pkgs, unstable-pkgs ? pkgs, definitions ? { } }:
let
  auth-helper = pkgs.callPackage ./auth-helper.nix { };
  chat-tools = pkgs.callPackage ./chat-tools.nix { inherit auth-helper; };
in {
  inherit auth-helper chat-tools;
}
