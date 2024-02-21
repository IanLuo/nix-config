{...}:
{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # moves focus between windows in the current focused display
      alt - h : yabai -m window --focus west
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - l : yabai -m window --focus east

      # rotate tree
      alt - r : yabai -m space --rotate 90

      # float / unfloat window and center on screen
      alt - t : yabai -m window --toggle float;\
                yabai -m window --grid 4:4:1:1:2:2

      # toggle window fullscreen zoom
      alt - f : yabai -m window --focus mouse && \
                yabai -m window --toggle zoom-fullscreen

      # balance size of windows
      alt - 0 : yabai -m space --balance
    '';
    };
}
