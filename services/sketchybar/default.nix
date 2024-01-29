{...}:

{
  config.services.sketchybar = {
    enable = true;
    config = ''
      ${builtins.readFile ./config/sketchybarrc}
    '';
  };
}
