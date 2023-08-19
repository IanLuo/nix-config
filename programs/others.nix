{
  programs.command-not-found.enable = true;

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.git = {
    enable = true;
    extraConfig = {
      core.editor = "vi";
    };
  };

  programs.zsh.enable = true;

  programs.tmate.enable = true;
}
