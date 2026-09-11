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
            previous_workspace = "prefix+p";        # back
            next_workspace = "prefix+shift+n";      # forward
            last_pane = "prefix+;";
          };

          ui = {
            show_agent_labels_on_pane_borders = true;
            toast.delivery = "herdr";
            # Show each agent's current context (terminal title) beside its name
            # in the sidebar's expanded agent rows.
            sidebar.agents = {
              row_gap = 0;
              rows = [
                [ "state_icon" "workspace" "tab" ]
                [ "agent" ]
                [ "terminal_title_stripped" ]
              ];
            };
          };

          theme = {
            name = "vesper";
            auto_switch = false;
          };
        };
      };
    };
}
