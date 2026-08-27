{ ... }:
# herdr — terminal workspace manager config (keybindings, ui, theme).
# Cross-platform (darwin + linux hosts). Config: ~/.config/herdr/config.toml.
{
  flake.modules.homeManager.herdr = { pkgs, ... }:
    let
      toml = pkgs.formats.toml { };
    in {
      xdg.configFile."herdr/config.toml" = {
        # force: file pre-existed as an unmanaged regular file (herdr's own
        # first-run config); home-manager now owns it.
        force = true;
        source = toml.generate "herdr-config" {
          onboarding = false;

          keys = {
            # PRD: herdr-prefix (ctrl+a) — one-handed prefix
            prefix = "ctrl+a";
            last_pane = "prefix+;";
            previous_workspace = "prefix+shift+p";
            next_workspace = "prefix+shift+n";

            previous_tab = "prefix+p";
            next_tab = "prefix+n";
          };

          ui = {
            show_agent_labels_on_pane_borders = true;
            toast.delivery = "herdr";
          };

          theme = {
            name = "vesper";
            auto_switch = false;
          };
        };
      };
    };
}
