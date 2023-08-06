{ pkgs, config, doom-emacs, inputs, ... }:
{ 
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom;
  };
}
