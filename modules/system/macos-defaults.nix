{ ... }:
# macOS system defaults applied via home-manager activation (darwin only —
# imported by the ianluo host). These are user-level `defaults` tweaks that
# fix fresh-machine annoyances.
{
  flake.modules.homeManager.macos-defaults = { lib, ... }: {
    home.activation.restoreKeyRepeat = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Restore held-key repeat: disable the accent-picker (press-and-hold)
      # that breaks h/j/k/l repeat in vim. Restart the terminal to apply.
      /usr/bin/defaults write -g ApplePressAndHoldEnabled -bool false
      # Snappier repeat (System Settings → Keyboard equivalents)
      /usr/bin/defaults write -g KeyRepeat -int 2
      /usr/bin/defaults write -g InitialKeyRepeat -int 25
      # Hide all desktop icons (files still accessible via Finder)
      /usr/bin/defaults write com.apple.finder CreateDesktop -bool false
      /usr/bin/killall Finder || true
      # Auto-hide the system menu bar (SketchyBar replaces it)
      /usr/bin/defaults write NSGlobalDomain _HIHideMenuBar -bool true
      # Hide the Dock (SketchyBar + AeroSpace replace it)
      /usr/bin/defaults write com.apple.dock autohide -bool true
      /usr/bin/defaults write com.apple.dock autohide-delay -float 1000
      /usr/bin/defaults write com.apple.dock autohide-time-modifier -float 0
      /usr/bin/killall Dock 2>/dev/null || true
    '';

    home.activation.hideDesktopIcons = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Hide desktop icons (cleaner desktop). Restarts Finder to apply.
      /usr/bin/defaults write com.apple.finder CreateDesktop -bool false
      /usr/bin/killall Finder 2>/dev/null || true
    '';
  };
}
