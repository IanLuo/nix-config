{ ... }:
# pi-harness — declarative ~/.pi/agent/ for the pi coding agent CLI.
# Owns only what the user authors: settings.json, a vendored extension set,
# and the nightfox theme.
#
# Deliberately NOT managed:
#   auth.json, trust.json, sessions/, models.json, models-store.json, npm/.
#   skills/ — ~/.pi/agent/skills/ is owned by the separate skills project
#   (~/Documents/apps/skills), which deploys its own symlinks. Do NOT add
#   skills here: nix must not own, force, or overwrite them.
# pi globs ~/.pi/agent/{extensions,themes,skills}/ on its own, so no
# settings.json `extensions`/`themes`/`skills` arrays are needed (themes.md,
# extensions.md, skills.md: "Locations").
#
# Read-only trade-off: home.file links settings.json to a read-only store path,
# so pi's own settings writes (Ctrl+S in /model or /thinking, /settings,
# /trust, `pi install`) never land on disk. This is a soft failure — pi 0.85.1
# enqueues the write and records the error as a diagnostic (dist/core/settings:
# `enqueueWrite` → `.catch(recordError)`), it does not abort or exit. Consequence:
# in-session changes work but do not persist, and lastChangelogVersion stays
# unset (so the changelog is simply not shown). Change settings HERE, not in
# /settings. Missing `packages` entries are still auto-installed at startup —
# that path only writes to ~/.pi/agent/npm/ (packages.md "Install and Manage").
{
  flake.modules.homeManager.pi-harness = { pkgs, lib, ... }:
    let
      json = pkgs.formats.json { };

      # Vendored pi 0.85.1 example extensions (programs/pi/extensions/,
      # verbatim apart from the provenance header). pi ships no built-in MCP,
      # sub-agents, plan mode, todos or permission prompts — extensions are
      # where those live (usage.md "Design Principles").
      extensions = [
        "protected-paths"     # block writes/edits to .env, .git/, node_modules/
        "confirm-destructive" # confirm session clear/switch/branch
        "dirty-repo-guard"    # refuse session changes with uncommitted changes
        "git-checkpoint"      # git stash checkpoint per turn, restorable on /fork
        "todo"                # todo tool + /todos command
        # "notify"              # OSC 777/99 desktop notification when the agent stops
      ];

    in {
      config.home.file =
        {
          ".pi/agent/settings.json" = {
            # force: pre-existed as an unmanaged regular file; home-manager
            # owns it from now on (same reason as modules/programs/herdr.nix).
            force = true;
            source = json.generate "pi-settings.json" {
              defaultProvider = "deepseek";
              defaultModel = "deepseek-v4-flash";
              defaultThinkingLevel = "high";
              theme = "nightfox";
              quietStartup = true;
              packages = [ "npm:pi-web-access" ];
            };
          };

          ".pi/agent/themes/nightfox.json".source = ../../programs/pi/themes/nightfox.json;
        }
        # Vendored extensions — auto-discovered from ~/.pi/agent/extensions/*.ts.
        // lib.listToAttrs (map (name: lib.nameValuePair ".pi/agent/extensions/${name}.ts" {
          source = ../../programs/pi/extensions/${name}.ts;
        }) extensions);
    };
}
