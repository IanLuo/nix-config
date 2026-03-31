{
  lib,
  unstable-pkgs,
  src,
  version,
}:
let
  pyPkgs = unstable-pkgs.python3Packages;
in
pyPkgs.buildPythonApplication {
  pname = "specify-cli";
  inherit version;
  pyproject = true;

  inherit src;

  build-system = with pyPkgs; [
    hatchling
  ];

  dependencies = with pyPkgs; [
    click
    httpx-socks
    httpx
    json5
    packaging
    pathspec
    platformdirs
    pyyaml
    readchar
    rich
    truststore
    typer
  ];

  nativeCheckInputs = with pyPkgs; [
    pytest
  ];

  pythonImportsCheck = [
    "specify_cli"
  ];

  meta = {
    description = "CLI for GitHub Spec Kit";
    homepage = "https://github.com/github/spec-kit";
    license = lib.licenses.mit;
    mainProgram = "specify";
  };
}
