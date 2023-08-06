{ pkgs, ...}:
{
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      fira-code-nerdfont
    ];
  };
}

