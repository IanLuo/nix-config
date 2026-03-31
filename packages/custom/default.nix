{ pkgs, unstable-pkgs ? pkgs, definitions ? { } }:
let
  versionFromSource = definition:
    let
      src = definition.src;
      match = builtins.match ".*/v([0-9]+\\.[0-9]+)$" src.url;
    in
    if definition ? version then definition.version
    else if src ? url && match != null then builtins.head match
    else "unstable-${builtins.substring 0 7 src.rev}";
in {
  specify-cli = pkgs.callPackage ./specify-cli.nix {
    inherit unstable-pkgs;
    src = definitions.specify-cli.src;
    version = versionFromSource definitions.specify-cli;
  };
}
