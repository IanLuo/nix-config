{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    newSession = true;
    escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.vim-tmux-navigator
    ];

    extraConfig = ''
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{command}:#(echo "#{pane_current_path}" | rev | cut -d'/' -f-3 | rev)'
      set-environment -g COLORTERM "truecolor"

      # Mouse works as expected
            set-option -g mouse on

      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"


      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
      bind-key -n 'Alt-h' if-shell "$is_vim" 'send-keys Alt-h'  'select-pane -L'
      bind-key -n 'Alt-j' if-shell "$is_vim" 'send-keys Alt-j'  'select-pane -D'
      bind-key -n 'Alt-k' if-shell "$is_vim" 'send-keys Alt-k'  'select-pane -U'
      bind-key -n 'Alt-l' if-shell "$is_vim" 'send-keys Alt-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'Alt-h' select-pane -L
      bind-key -T copy-mode-vi 'Alt-j' select-pane -D
      bind-key -T copy-mode-vi 'Alt-k' select-pane -U
      bind-key -T copy-mode-vi 'Alt-l' select-pane -R
      bind-key -T copy-mode-vi 'Alt-\' select-pane -l

      set -o vi
    '';
  };
}
