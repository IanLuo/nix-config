{
stdenv
, pkgs
, lib
, unstable-pkgs ? pkgs  # Default to stable if not provided
, system ? "aarch64-darwin"
} :
let
  # Stable packages - core system tools that should be stable
  stablePackages = with pkgs; [
    git              # Version control - stability important
    gcc              # Compiler - compatibility critical
    curl wget        # Network tools - stability over features
    tree             # File listing - rarely changes
    zsh              # Shell - stability important
    # tmux             # Terminal multiplexer - stability over features
    direnv           # Environment management - stability important
    nix-direnv       # Nix integration - stability important
    any-nix-shell    # Shell integration - stability important
    tmate            # Terminal sharing - stability over features
    manix            # Nix manual - stable documentation
    nix-prefetch-git # Tool for getting SHA256 hashes - utility tool
    uv

    (writeShellScriptBin "agy" ''
      # Targeted approach for Antigravity (VSCode/Electron based)
      APP_PATH="/Applications/Antigravity.app"

      # 1. Try to find the official CLI script (usually in Resources/app/bin)
      # This is the correct way to launch VSCode-like apps with arguments and env
      CLI_DIR="$APP_PATH/Contents/Resources/app/bin"

      if [ -d "$CLI_DIR" ]; then
        # Look for the main executable script in bin
        # It is often named 'code' or 'antigravity'
        # We try to find 'antigravity' first, then 'code', then any executable
        if [ -x "$CLI_DIR/antigravity" ]; then
          exec "$CLI_DIR/antigravity" "$@"
        elif [ -x "$CLI_DIR/code" ]; then
          exec "$CLI_DIR/code" "$@"
        else
          # Find the first executable file in the dir
          SCRIPT=$(find "$CLI_DIR" -maxdepth 1 -type f -perm +111 | head -n 1)
          if [ -n "$SCRIPT" ]; then
             exec "$SCRIPT" "$@"
          fi
        fi
      fi

      # 2. Fallback: Try to find 'antigravity' binary in MacOS folder directly
      # (Only if the CLI script method failed/didn't exist)
      if [ -f "$APP_PATH/Contents/MacOS/Antigravity" ]; then
         # Warning: Direct execution might fail auth/env setup
         echo "Warning: Using direct binary execution. Authentication might fail." >&2
         exec "$APP_PATH/Contents/MacOS/Antigravity" "$@"
      else
         echo "Error: Could not find Antigravity app or CLI script." >&2
         exit 1
      fi
    '')
  ] ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)); # Fonts - stability over features

  # Unstable packages - development tools that benefit from latest versions
  unstablePackages = with unstable-pkgs; [
    # nodejs           # Rapid development, new features
    nixd             # Nix language server - latest fixes
    ripgrep fd       # Search tools - performance improvements
    podman           # Container runtime - latest features
    nix-index        # Package search - latest package data
    nix-tree         # Nix visualization - improvements
    nix-du           # Nix disk usage - latest features
    # dbeaver-bin      # Database tool - latest features
    # element-desktop  # Matrix client - latest features
    nnn              # File manager - latest features
    # gemini-cli       # Official Gemini CLI from nixpkgs-unstable
  ];

  # macOS-specific packages (stable unless noted)
  darwinPackages = with pkgs; [
    m-cli            # Stable - CLI for macOS
  ] ++ (with unstable-pkgs; [
    # discord          # Unstable - latest features
    # raycast          # Unstable - latest features
    # sketchybar-app-font  # Unstable - latest features
  ]);

  # Bleeding-edge packages - for rapidly evolving software
  bleedingEdge = import ./bleeding-edge { inherit pkgs lib system; };

  packages = stablePackages ++ unstablePackages ++ (lib.optionals stdenv.isDarwin darwinPackages) ++ bleedingEdge.packages;
in {
  inherit packages;
  inherit stablePackages unstablePackages darwinPackages;
}
