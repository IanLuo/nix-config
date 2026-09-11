{
  flake.modules.homeManager.cli = {
    programs.command-not-found.enable = true;

    programs.btop.enable = true; # replaces htop — same job, modern visuals

    programs.fzf.enable = true;

    programs.git = {
      enable = true;
      settings = {
        core.editor = "vi";
      };
    };

    programs.tmate.enable = true;
  };
}
