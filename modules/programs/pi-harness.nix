{ ... }:
# pi-harness — declarative ~/.pi/agent/ for the pi coding agent CLI.
# Owns only the vendored extension set and the nightfox theme.
#
# Deliberately NOT managed:
#   settings.json, auth.json, trust.json, sessions/, models.json,
#   models-store.json, npm/.
#   settings.json is magpie's (`magpie pi <model>` sets defaultProvider and
#   defaultModel there, `magpie save`/`use` snapshots it). home.file would link
#   it to a read-only store path and magpie's in-place write fails with EACCES,
#   so nix must not own it. pi's own writes (Ctrl+S in /model or /thinking,
#   /settings, `pi install`) also persist only while the file is a real file.
#   skills/ — ~/.pi/agent/skills/ is owned by the separate skills project
#   (~/Documents/apps/skills), which deploys its own symlinks. Do NOT add
#   skills here: nix must not own, force, or overwrite them.
# pi globs ~/.pi/agent/{extensions,themes,skills}/ on its own, so no
# settings.json `extensions`/`themes`/`skills` arrays are needed (themes.md,
# extensions.md, skills.md: "Locations").
{
  flake.modules.homeManager.pi-harness = { lib, ... }:
    let
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
          ".pi/agent/themes/nightfox.json".source = ../../programs/pi/themes/nightfox.json;
        }
        # Vendored extensions — auto-discovered from ~/.pi/agent/extensions/*.ts.
        // lib.listToAttrs (map (name: lib.nameValuePair ".pi/agent/extensions/${name}.ts" {
          source = ../../programs/pi/extensions/${name}.ts;
        }) extensions);
    };
}
