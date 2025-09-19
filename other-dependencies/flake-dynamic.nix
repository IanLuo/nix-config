{ pkgs, lib, inputs, ... }:

let
  # Import tool configurations
  toolsConfig = import ./tools-config.nix;

  # Helper function to generate pyproject.toml content
  generatePyprojectContent = deps:
    let
      dependencies = lib.mapAttrsToList (name: config:
        if config ? "version" then
          "${name}==${config.version}"
        else
          name
      ) deps;
    in
    ''
      [project]
      name = "gemini-managed-python-env"
      version = "0.1.0"
      dependencies = [
        ${lib.concatStringsSep ",
" (lib.map (dep: ''"${dep}"'') dependencies)}
      ]
    '';

  # Derivation for the Python environment
  pythonEnv = let
    pyprojectContent = generatePyprojectContent toolsConfig.python;
  in pkgs.stdenv.mkDerivation {
    name = "python-env";
    nativeBuildInputs = [ pkgs.uv ];
    dontUnpack = true;
    __noChroot = true;

    buildPhase = ''
      export HOME=$(mktemp -d)
      cat <<EOF > pyproject.toml
      ${pyprojectContent}
      EOF
      uv venv -p ${pkgs.python312.interpreter}
      source ./.venv/bin/activate && uv pip install -r pyproject.toml
      # Generate lock file
      source ./.venv/bin/activate && uv lock
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp ./.venv/bin/* $out/bin/
      # Also copy the lock file
      cp uv.lock $out/
    '';
  };

  # Helper function to generate package.json content
  generatePackageJsonContent = deps:
    let
      dependencies = lib.mapAttrs' (name: config: {
        name = if config ? "package" then config.package else name;
        value = if config ? "version" then config.version else "*";
      }) deps;
    in
    builtins.toJSON {
      name = "gemini-managed-nodejs-env";
      version = "1.0.0";
      dependencies = dependencies;
    };

  # Derivation for the Node.js environment
  nodejsEnv = let
    packageJsonContent = generatePackageJsonContent toolsConfig.nodejs;
  in pkgs.stdenv.mkDerivation {
    name = "nodejs-env";
    nativeBuildInputs = [ pkgs.nodejs_20 pkgs.cacert ];
    dontUnpack = true;
    __noChroot = true;

    buildPhase = ''
      export HOME=$(mktemp -d)
      export NPM_CONFIG_CAFILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      cat <<EOF > package.json
      ${packageJsonContent}
      EOF
      npm install
    '';

    
    installPhase = ''
      mkdir -p $out/node_modules
      cp -r -a node_modules/. $out/node_modules/
      mkdir -p $out/bin

      for file in $out/node_modules/.bin/*; do
        ln -s "$file" "$out/bin/$(basename $file)"
      done

      cp package-lock.json $out/
    '';


    fixupPhase = ''
      patchShebangsFollowLinks() {
        local dir=$1
        find "$dir" -type f -exec patchShebangs {} \;
        find "$dir" -type l | while read link; do
          target=$(readlink -f "$link")
          if [ -f "$target" ]; then
            patchShebangs "$target"
          fi
        done
      }

      patchShebangsFollowLinks $out/bin
    '';
  };

in
{
  home.packages = [
    pythonEnv
    nodejsEnv
  ];

  home.sessionVariables = {
    UV_CACHE_DIR = "$HOME/.cache/uv";
  };
}
