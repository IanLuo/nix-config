{
  lib,
  python3Packages,
  src,
  version,
}:
python3Packages.buildPythonApplication {
  pname = "specify-cli";
  inherit version;
  pyproject = true;

  inherit src;

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
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

  nativeCheckInputs = with python3Packages; [
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
