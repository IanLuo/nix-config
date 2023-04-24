{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    newSession = true;
    escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.sensible
      tmuxPlugins.jump
    ];

    extraConfig = ''
        set -g default-terminal "screen-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#{command}:#(echo "#{pane_current_path}" | rev | cut -d'/' -f-3 | rev)'
        set-environment -g COLORTERM "truecolor"
        set-window-option -g mode-keys vi

      # Mouse works as expected
        set-option -g mouse on

      # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        unbind C-b
        set -g prefix C-a
        bind C-a send-prefix
    '';
  };
}
