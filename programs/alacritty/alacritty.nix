{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Fira Code";
          style = "Regular";
        };
        bold = {
          family = "Fira Code";
          style = "Bold";
        };
        italic = {
          family = "Fira Code";
          style = "Italic";
        };
        bold_italic = {
          family = "Fira Code";
          style = "Bold Italic";
        };
      };
      window = {
        padding = {
          x = 10;
          y = 10;
        };
      };
      key_bindings = [
        {
          key = "F12";
          mods = "SUPER";
          action = "SpawnNewInstance";
        }
      ];
    };
  };
}
