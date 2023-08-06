{ pkgs, lib, config, ... } : 
with lib;
let 
  cfg = config.system.keyboard;
  keyBase = 0x700000000;
  escape = keyBase + 0x29;
  caplock = keyBase + 0x39;
  leftControl = keyBase + 0xe0;
  leftAlt = keyBase + 0xe2;
  leftMeta = keyBase + 0xe3;
in
{
  options = {
    system.keyboard.enableKeyMapping = mkOption {
      type = types.bool;
      default = false;
    };

    system.keyboard.remapAToB = mkOption {
      type = types.bool;
      default = false;
    };

    system.keyboard.userKeyMapping = mkOption {
      type = types.listOf (types.attrsOf types.int);
      default = [];
    };
  };

  config = {
    system.keyboard.enableKeyMapping = mkDefault (cfg.userKeyMapping != []);

    system.keyboard.userKeyMapping = mkMerge [
      (mkIf cfg.remapAToB [ { HIDKEYboardModifierMappingSrc = caplock; HIDkeyboardModifierMappingDst = leftControl; } ])
      (mkIf cfg.remapAToB [ { HIDKEYboardModifierMappingSrc = leftControl; HIDkeyboardModifierMappingDst = caplock; } ])
      (mkIf cfg.remapAToB [ { HIDKEYboardModifierMappingSrc = leftAlt; HIDkeyboardModifierMappingDst = escape; } ])
    ];

    system.activationScripts.keyboard.text = optionalString cfg.enableKeyMapping ''
      # Configuring keyboard
      echo "remapping keys..." >&2
      hidutil property --set '{"UserKeyMapping:":${builtins.toJSON cfg.userKeyMapping}}'
    '';
  };
}
