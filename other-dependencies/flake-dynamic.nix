{ pkgs, lib, inputs, ... }:

let
  # Import tool configurations
  toolsConfig = import ./tools-config.nix;

  # Helper function to generate pyproject.toml content
  generatePyprojectContent = deps:
    let
      dependencies = lib.mapAttrsToList (name: config:
        if config ? "version" then
          ''"${name}==${config.version}"''
        else if config.source == "git" then
          ''"${name} @ git+${config.url}@${config.rev}"''
        else
          name
      ) deps;
    in
    ''
      [project]
      name = "gemini-managed-python-env"
      version = "0.1.0"
      dependencies = [
        ${lib.concatStringsSep ",\n" dependencies}
      ]
    ''
;

  # Derivation for the Python environment
  pythonEnv = let
    pyprojectContent = generatePyprojectContent toolsConfig.python;
  in pkgs.stdenv.mkDerivation {
    name = "python-env";
    nativeBuildInputs = [ pkgs.uv pkgs.git pkgs.cacert ];
    dontUnpack = true;
    __noChroot = true;

    buildPhase = ''
      export HOME=$(mktemp -d)
      export GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      cat <<EOF > pyproject.toml
      ${pyprojectContent}
      EOF
      uv venv -p ${pkgs.python312.interpreter}
      source ./.venv/bin/activate && uv pip install -r pyproject.toml
      # Generate lock file
      source ./.venv/bin/activate && uv pip compile pyproject.toml -o requirements.lock
    '';

    installPhase = ''
      set -x
      mkdir -p $out/bin
      mkdir -p $out/libexec/${pythonEnv.name}
      cp -r ./.venv/* $out/libexec/${pythonEnv.name}/

      # Fix shebangs in all Python executables to point to the correct Python interpreter
      find $out/libexec/${pythonEnv.name}/bin -type f -executable | while read file; do
        if head -n1 "$file" | grep -q "python"; then
          sed -i "1s|.*|#!${pkgs.python312}/bin/python3|" "$file"
          echo "Fixed shebang for: $file"
        fi
      done

      echo "Contents of $out/libexec/${pythonEnv.name}/bin/:"
      ls -l $out/libexec/${pythonEnv.name}/bin/

      echo "otool -L output for specify:"
      otool -L $out/libexec/${pythonEnv.name}/bin/specify || true

      for file in $out/libexec/${pythonEnv.name}/bin/*; do
        if [ -f "$file" ] && [ -x "$file" ]; then
          local exeName=$(basename "$file")
          cat > "$out/bin/$exeName" <<EOF
#!${pkgs.stdenv.shell}
export PATH="${pkgs.python312}/bin:$out/libexec/${pythonEnv.name}/bin:\$PATH"
export PYTHONPATH="$out/libexec/${pythonEnv.name}/lib/python3.12/site-packages:\$PYTHONPATH"
export DYLD_LIBRARY_PATH="${pkgs.python312}/lib:$out/libexec/${pythonEnv.name}/lib:\$DYLD_LIBRARY_PATH"
exec -a "\$0" "$out/libexec/${pythonEnv.name}/bin/$exeName" "\$@"
EOF
          chmod +x "$out/bin/$exeName"
        fi
      done

      echo "Contents of $out/bin/:";
      ls -l $out/bin/

      # Also copy the lock file
      cp requirements.lock $out/
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

      for file in $out/node_modules/.bin/*;
      do
        ln -s "$file" "$out/bin/$(basename $file)"
      done

      cp package-lock.json $out/
    '';


    fixupPhase = ''
      patchShebangsFollowLinks() {
        local dir=$1
        find "$dir" -type f -exec patchShebangs {} \;
        find "$dir" -type l | while read link;
        do
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
