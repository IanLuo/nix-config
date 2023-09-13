{ pkgs, ...}:
{
  imports = [
    # ./lorri 
    # ./emacs
  ];

  services.sketchybar.enable = true;
}
