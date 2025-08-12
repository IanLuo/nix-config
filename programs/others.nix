{
  # Environment variables
  home.sessionVariables = {
    GEMINI_API_KEY = "AIzaSyCo-x7ptTUM_HvcZzCCO5ToJgXU9cu780M";
  };

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

  programs.tmate.enable = true;

}
