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
            next_workspace = "prefix+n";      # forward
            last_pane = "prefix+;";
          };

          ui = {
            # Accent for highlights, borders and navigation UI. This is a UI key,
            # NOT theme.custom.accent: unset, it defaults to the named colour
            # "cyan", which resolves through the base palette instead of
            # nightfox. Pin it explicitly.
            accent = "#719cd6";
            show_agent_labels_on_pane_borders = true;
            toast.delivery = "herdr";

            # Sidebar rows take inline style tables: `fg`, `bold`, `dim`, and
            # ordered `rules` that restyle a token by its value (first match
            # wins). git_status is deliberately left unstyled — a foreground
            # override would collapse its green/red ahead/behind colours.
            # Show each agent's current context (terminal title) beside its name
            # in the sidebar's expanded agent rows.
            sidebar.agents = {
              row_gap = 0;
              rows = [
                [ "state_icon" { token = "workspace"; bold = true; } { token = "tab"; dim = true; } ]
                [
                  { token = "agent"; bold = true; }
                  {
                    token = "state_text";
                    rules = [
                      { equals = "blocked"; fg = "#c94f6d"; bold = true; }
                      { equals = "working"; fg = "#dbc074"; }
                      { equals = "done"; fg = "#81b29a"; }
                      { equals = "idle"; dim = true; }
                    ];
                  }
                ]
                [ { token = "terminal_title_stripped"; dim = true; } ]
              ];
            };

            sidebar.spaces = {
              row_gap = 0;
              rows = [
                [ "state_icon" { token = "workspace"; bold = true; } ]
                [ { token = "branch"; fg = "#719cd6"; } "git_status" ]
              ];
            };
          };

          theme = {
            # "terminal" rather than a named palette: herdr layers
            # [theme.custom] on top of the base, and every colour token it
            # exposes is overridden below. Using the host terminal as the base
            # means anything derived rather than overridden inherits from the
            # nightfox surface we already sit in, not a foreign palette.
            name = "terminal";
            auto_switch = false;

            # nightfox palette — canonical values from nightfox.nvim 3.10.0
            # (lua/nightfox/palette/nightfox.lua), matching nvim, the terminal
            # background and sketchybar. Every colour token herdr exposes is
            # overridden, so the built-in name only provides the base shape.
            custom = {
              # blue is the machine-wide accent (sketchybar COLOR_ACCENT).
              accent = "#719cd6";
              blue = "#719cd6";
              teal = "#63cdcf";      # cyan
              green = "#81b29a";
              yellow = "#dbc074";
              red = "#c94f6d";
              mauve = "#9d79d6";     # magenta
              peach = "#f4a261";     # orange
              text = "#cdcecf";      # fg1 — same value as sketchybar COLOR_FG
              subtext0 = "#aeafb0";  # fg2
              # Inactive pane borders are drawn with overlay0 — herdr exposes no
              # per-focus or per-border control, so this token is the only lever.
              #
              # Do NOT use "transparent"/"none"/"reset" here: those drop the
              # colour, and herdr still draws the glyphs in the terminal's
              # DEFAULT foreground (measured: 206 border glyphs emitted). Painting
              # the nightfox background colour is what actually makes them read
              # as hidden — at the cost of the sidebar "spaces" header and the
              # prefix-mode hint bar (new/menu/agents), which share this token and
              # therefore also fade into the background.
              overlay0 = "#192330";
              overlay1 = "#738091";  # comment
              surface_dim = "#131a24"; # bg0
              surface0 = "#212e3f";  # bg2
              surface1 = "#29394f";  # bg3
              panel_bg = "#212e3f";  # bg2
              active_row_bg = "#2b3b51"; # sel0
              selection_bg = "#3c5372";  # sel1
              # Keep the host terminal's translucent nightfox background instead
              # of painting the sidebar an opaque colour.
              sidebar_bg = "reset";
            };
          };
        };
      };
    };
}
