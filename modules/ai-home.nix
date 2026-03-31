{ inputs, lib, ... }:
let
  flakeLib = lib;
  agentSkillLinkTargets = {
    codex = ".codex/skills";
    claude = ".claude/skills";
    opencode = ".config/opencode/skills";
    gemini = ".gemini/skills";
  };

  inherit (flakeLib)
    concatMapStringsSep
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optionalAttrs
    types;

  resourcesRoot = ../resources/ai;
  sharedSkillsPath = resourcesRoot + "/skills";
  codexGlobalInstructions = resourcesRoot + "/instructions/codex/AGENTS.md";
  claudeGlobalInstructions = resourcesRoot + "/instructions/claude/CLAUDE.md";
  opencodeGlobalInstructions = resourcesRoot + "/instructions/opencode/AGENTS.md";
in {
  flake.modules.homeManager."ai-home" = { config, lib, pkgs, ... }:
    let
      cfg = config.programs.aiHome;
      jsonType = (pkgs.formats.json { }).type;
      sharedSkillsHomePath = "$HOME/${cfg.shared.homeSkillsDir}";

      skillSources =
        lib.optional cfg.shared.enableSkills cfg.shared.skillsPath
        ++ lib.optionals cfg.sources.gstack.enable [ cfg.sources.gstack.package ];

      sharedSkillLinkScript =
        pkgs.writeShellScript "ai-home-link-shared-skills" ''
          set -euo pipefail

          shared_target="${sharedSkillsHomePath}"
          rm -rf "$shared_target"
          mkdir -p "$shared_target"

          ${concatMapStringsSep "\n" (source: ''
            if [ -d "${source}/share/gstack/skills" ]; then
              ln -sfn "${source}/share/gstack/skills/gstack" "$shared_target/gstack"
              for skill_dir in "${source}/share/gstack/skills"/*; do
                if [ -d "$skill_dir" ] && [ "$(basename "$skill_dir")" != "gstack" ]; then
                  ln -sfn "$skill_dir" "$shared_target/$(basename "$skill_dir")"
                fi
              done
            else
              for skill_dir in "${source}"/*; do
                if [ -d "$skill_dir" ]; then
                  ln -sfn "$skill_dir" "$shared_target/$(basename "$skill_dir")"
                fi
              done
            fi
          '') skillSources}

          ${concatMapStringsSep "\n" (agent: let
            target = agentSkillLinkTargets.${agent};
          in ''
            mkdir -p "$HOME/$(dirname "${target}")"
            rm -rf "$HOME/${target}"
            ln -sfn "$shared_target" "$HOME/${target}"
          '') cfg.shared.supportedAgents}
        '';
    in {
      options.programs.aiHome = {
        enable = mkEnableOption "shared AI home configuration";

        shared = {
          enableSkills = mkOption {
            type = types.bool;
            default = true;
            description = "Expose the shared agent-skills tree to enabled adapters.";
          };

          enableGlobalInstructions = mkOption {
            type = types.bool;
            default = true;
            description = "Expose adapter-specific global instruction files generated from shared resources.";
          };

          skillsPath = mkOption {
            type = types.path;
            default = sharedSkillsPath;
            description = "Canonical shared skills directory.";
          };

          homeSkillsDir = mkOption {
            type = types.str;
            default = ".agents/skills";
            description = "Canonical home-relative skills directory used as the shared adapter target.";
          };

          supportedAgents = mkOption {
            type = types.listOf (types.enum [
              "codex"
              "claude"
              "opencode"
              "gemini"
            ]);
            default = [
              "codex"
              "opencode"
            ];
            description = "Coding agents that should receive a symlink to the shared home-level skills directory.";
          };
        };

        sources = {
          gstack = {
            enable = mkOption {
              type = types.bool;
              default = false;
              description = "Install the packaged gstack skill bundle.";
            };

            package = mkOption {
              type = types.package;
              description = "Packaged gstack bundle to expose through the shared skills directory.";
            };
          };
        };

        adapters = {
          codex.enable = mkOption {
            type = types.bool;
            default = true;
            description = "Enable the Codex adapter.";
          };

          claude.enable = mkOption {
            type = types.bool;
            default = false;
            description = "Enable the Claude Code adapter.";
          };

          opencode = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = "Enable the OpenCode adapter.";
            };

            package = mkOption {
              type = types.package;
              default = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
              description = "OpenCode package to install when the adapter is enabled.";
            };

            enablePackage = mkOption {
              type = types.bool;
              default = true;
              description = "Install the OpenCode package when the adapter is enabled.";
            };

            enableModule = mkOption {
              type = types.bool;
              default = true;
              description = "Enable Home Manager's programs.opencode module for adapter-managed config.";
            };

            settings = mkOption {
              type = jsonType;
              default = {
                autoupdate = true;
              };
              description = "OpenCode settings merged into opencode.json.";
            };
          };
        };
      };

      config = mkIf cfg.enable (mkMerge [
        {
          assertions = [
            {
              assertion = !cfg.shared.enableSkills || builtins.pathExists cfg.shared.skillsPath;
              message = "programs.aiHome.shared.skillsPath must exist when shared skills are enabled.";
            }
          ];

          programs.aiHome = {
            shared = {
              enableSkills = lib.mkDefault true;
              enableGlobalInstructions = lib.mkDefault true;
              supportedAgents = lib.mkDefault [
                "codex"
                "opencode"
              ];
            };

            adapters = {
              codex.enable = lib.mkDefault true;
              claude.enable = lib.mkDefault false;
              opencode = {
                enable = lib.mkDefault true;
                enablePackage = lib.mkDefault true;
                enableModule = lib.mkDefault true;
              };
            };

            sources = {
              gstack.enable = lib.mkDefault false;
            };
          };
        }

        {
          home.activation.linkSharedAgentSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            ${sharedSkillLinkScript}
          '';
        }

        (mkIf cfg.adapters.codex.enable {

          home.file = optionalAttrs cfg.shared.enableGlobalInstructions {
            ".codex/AGENTS.md".source = codexGlobalInstructions;
          };
        })

        (mkIf cfg.adapters.claude.enable {
          home.file = optionalAttrs cfg.shared.enableGlobalInstructions {
            ".claude/CLAUDE.md".source = claudeGlobalInstructions;
          };
        })

        (mkIf cfg.adapters.opencode.enable (mkMerge [
          (mkIf cfg.adapters.opencode.enablePackage {
            home.packages = [ cfg.adapters.opencode.package ];
          })
          {
            home.sessionVariables = {
              GEMINI_API_KEY = "";
            };
          }
          (mkIf cfg.adapters.opencode.enableModule {
            programs.opencode = mkMerge [
              {
                enable = true;
                package = cfg.adapters.opencode.package;
                settings = cfg.adapters.opencode.settings;
              }
              (optionalAttrs cfg.shared.enableGlobalInstructions {
                rules = opencodeGlobalInstructions;
              })
            ];
          })
          (mkIf (!cfg.adapters.opencode.enableModule) {
            xdg.configFile = optionalAttrs cfg.shared.enableGlobalInstructions {
              "opencode/AGENTS.md".source = opencodeGlobalInstructions;
            };
          })
        ]))
      ]);
    };
}
