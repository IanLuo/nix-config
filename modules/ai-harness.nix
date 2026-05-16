{
  flake.modules.homeManager.ai-harness = { pkgs, lib, ... }:
  let
    skillsSrc = ../resources/ai/skills;
    hasSkills = builtins.pathExists skillsSrc && (builtins.readDir skillsSrc != { });

    skillsDrv = pkgs.runCommand "ai-harness-skills" { } (
      if hasSkills then ''
        mkdir -p "$out"
        cp -r ${skillsSrc}/* "$out"/
      '' else ''
        mkdir -p "$out"
      ''
    );
  in {
    home.activation.linkSharedSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      "set -euo pipefail\n"
      + "TARGET=\"$HOME/.agents/skills\"\n"
      + "mkdir -p \"$TARGET\"\n"
      + "\n"
      + "for entry in \"$TARGET\"/* \"$TARGET\"/.*; do\n"
      + "  [ -e \"$entry\" ] || continue\n"
      + "  name=\"$(basename \"$entry\")\"\n"
      + "  [ \"$name\" = \".\" ] && continue\n"
      + "  [ \"$name\" = \"..\" ] && continue\n"
      + "  [ \"$name\" = \".system\" ] && continue\n"
      + "  if [ -L \"$entry\" ]; then\n"
      + "    link_target=\"$(readlink \"$entry\")\"\n"
      + "    case \"$link_target\" in\n"
      + "      /nix/store/*)\n"
      + "        if [ ! -e \"$entry\" ]; then\n"
      + "          rm \"$entry\"\n"
      + "          echo \"ai-harness: removed stale symlink $name\"\n"
      + "        fi\n"
      + "        ;;\n"
      + "    esac\n"
      + "  fi\n"
      + "done\n"
      + "\n"
      + "if [ -d \"${skillsDrv}\" ]; then\n"
      + "  for skill in \"${skillsDrv}\"/*/; do\n"
      + "    [ -d \"$skill\" ] || continue\n"
      + "    name=\"$(basename \"$skill\")\"\n"
      + "    ln -sfn \"$skill\" \"$TARGET/$name\"\n"
      + "    echo \"ai-harness: linked $name\"\n"
      + "  done\n"
      + "fi\n"
    );
  };
}