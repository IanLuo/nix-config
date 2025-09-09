{ pkgs, lib, inputs, ... }:

let
  # Import tool configurations
  toolsConfig = import ./tools-config.nix;
  
  # Helper functions for different source types
  builders = {
    # Build from nixpkgs
    buildFromNixpkgs = name: config: pkgs.python312Packages.${name} or pkgs.${name};
    
    # Build from GitHub source using fetchFromGitHub
    buildFromGithub = name: config: pkgs.stdenv.mkDerivation rec {
      pname = name;
      version = config.rev;
      
      src = pkgs.fetchFromGitHub {
        owner = config.owner;
        repo = config.repo;
        rev = config.rev;
        sha256 = config.sha256;
      };
      
      nativeBuildInputs = config.nativeBuildInputs or [ pkgs.nodejs_20 ];
      
      buildPhase = config.buildPhase or ''
        if [ -f "package.json" ]; then
          ${pkgs.nodejs_20}/bin/npm install && ${pkgs.nodejs_20}/bin/npm run build
        elif [ -f "Cargo.toml" ]; then
          ${pkgs.cargo}/bin/cargo build --release
        fi
      '';
      
      installPhase = config.installPhase or ''
        mkdir -p $out/bin
        if [ -f "target/release/${name}" ]; then
          cp target/release/${name} $out/bin/
        elif [ -f "dist/index.js" ]; then
          cp dist/index.js $out/bin/${name}
          chmod +x $out/bin/${name}
        fi
      '';
    };
    
    # Build from npm package
    buildFromNpm = name: config: pkgs.stdenv.mkDerivation rec {
      pname = name;
      version = config.version;
      
      dontUnpack = true;
      
      nativeBuildInputs = [ pkgs.nodejs_20 pkgs.cacert ];
      
      configurePhase = ''
        export HOME=$TMPDIR
        export NPM_CONFIG_CACHE=$TMPDIR/npm-cache
        export NPM_CONFIG_FUND=false
        
        # Fix SSL certificate issues
        export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
        export NODE_EXTRA_CA_CERTS=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
        export NPM_CONFIG_CAFILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      '';
      
      buildPhase = ''
        # Install directly to output directory
        npm install --global --prefix $out ${config.package}@${config.version}
      '';
      
      installPhase = ''
        # npm global install should have created everything we need
        echo "Installation completed. Contents of $out:"
        find $out -type f -name "*gemini*" -o -name "*" -path "*/bin/*" | head -10
        
        # Fix shebang lines in any JavaScript files that should be executables
        find $out -name "*.js" -path "*/bin/*" -o -name "*.js" -executable | while read -r file; do
          if head -1 "$file" | grep -q "#!/usr/bin/env node"; then
            sed -i "1s|#!/usr/bin/env node|#!${pkgs.nodejs_20}/bin/node|" "$file"
            echo "Fixed shebang in: $file"
          fi
        done
        
        # Also fix any files with node in the shebang in lib directories that might be executables
        find $out -name "index.js" -o -name "cli.js" -o -name "bin.js" | while read -r file; do
          if head -1 "$file" | grep -q "#!/usr/bin/env node"; then
            sed -i "1s|#!/usr/bin/env node|#!${pkgs.nodejs_20}/bin/node|" "$file"
            echo "Fixed shebang in: $file"
          fi
        done
      '';
      
      meta = with pkgs.lib; {
        description = "npm package ${config.package}";
        platforms = platforms.all;
      };
    };
  };
  
  # Function to build a tool based on its configuration
  buildTool = category: name: config: 
    let
      source = config.source;
      builderMap = {
        "nixpkgs" = builders.buildFromNixpkgs;
        "github" = builders.buildFromGithub;
        "npm" = builders.buildFromNpm;
      };
      builder = builderMap.${source} or (throw "Unknown source type: ${source} for tool ${name}. Supported: nixpkgs, github, npm");
    in
    builder name config;
  
  # Generate all tools from configuration
  allTools = lib.flatten (
    lib.mapAttrsToList (category: tools: 
      lib.mapAttrsToList (name: config: buildTool category name config) tools
    ) toolsConfig
  );
  
  # Generate information about all tools
  toolInfo = lib.flatten (
    lib.mapAttrsToList (category: tools:
      lib.mapAttrsToList (name: config: {
        inherit name category;
        source = config.source;
        version = config.version or config.rev or "nixpkgs";
        package = config.package or name;
        # For npm packages, the binary name might be different from the tool name
        binaryName = if config.source == "npm" then 
          (if config.package == "@google/gemini-cli" then "gemini" else name)
          else name;
      }) tools
    ) toolsConfig
  );

in
{
  # Add all dynamically built tools
  home.packages = allTools ++ [
    # Information script about all tools
    (pkgs.writeShellScriptBin "list-flake-tools" ''
      echo "=== Global Tools (Flake-based) ==="
      echo ""
      ${lib.concatMapStringsSep "\n      " (tool: ''
        echo "[${tool.category}] ${tool.name}:"
        echo "  Source: ${tool.source}"
        echo "  Version: ${tool.version}"
        echo "  Package: ${tool.package}"
                echo "  Available: $(which ${tool.binaryName} >/dev/null 2>&1 && echo "✅ Yes" || echo "❌ No")"
        echo ""
      '') toolInfo}
    '')
  ];
  
  # Environment variables
  home.sessionVariables = {
    UV_CACHE_DIR = "$HOME/.cache/uv";
  };
}
