{ ... }:
# herdr — terminal workspace manager config (keybindings, ui, theme).
# Cross-platform (darwin + linux hosts). Config: ~/.config/herdr/config.toml.
{
  flake.modules.homeManager.herdr = { pkgs, ... }:
    let
      toml = pkgs.formats.toml { };
    in {
      xdg.configFile."herdr/config.toml" = {
        source = toml.generate "herdr-config" {
          onboarding = false;

          keys = {
            # PRD: herdr-prefix (ctrl+a) — one-handed prefix
            prefix = "ctrl+a";
            last_pane = "prefix+;";
          };

          ui = {
            show_agent_labels_on_pane_borders = true;
            toast.delivery = "herdr";
          };

          theme = {
            name = "terminal";
            auto_switch = false;
          };
        };
      };
    };
}
