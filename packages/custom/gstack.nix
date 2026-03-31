{
  lib,
  git,
  bun2nix,
  src,
  version,
}:
let
  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ./gstack-bun.nix;
  };
in
bun2nix.mkDerivation {
  pname = "gstack";
  inherit version src;

  inherit bunDeps;
  module = "scripts/gen-skill-docs.ts";

  nativeBuildInputs = [
    git
  ];

  strictDeps = true;

  env = {
    HOME = "/build/gstack-home";
  };

  buildPhase = ''
    mkdir -p "$HOME"

    bun run build
    bun run gen:skill-docs --host codex
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/gstack/skills"
    mkdir -p "$out/share/gstack/runtime/gstack"

    cp -R .agents/skills/. "$out/share/gstack/skills/"

    cp -R bin "$out/share/gstack/runtime/gstack/"
    mkdir -p "$out/share/gstack/runtime/gstack/browse"
    cp -R browse/dist "$out/share/gstack/runtime/gstack/browse/"
    if [ -d browse/bin ]; then
      cp -R browse/bin "$out/share/gstack/runtime/gstack/browse/"
    fi
    cp -R review "$out/share/gstack/runtime/gstack/"
    cp ETHOS.md "$out/share/gstack/runtime/gstack/"

    ln -s "$out/share/gstack/runtime/gstack" "$out/share/gstack/skills/gstack"

    runHook postInstall
  '';

  meta = {
    description = "Packaged gstack skill bundle";
    homepage = "https://github.com/garrytan/gstack";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
