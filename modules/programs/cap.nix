{ inputs, ... }:
# cap — the fs board watcher, supervised by launchd (KeepAlive). The module and
# the package come from the cap flake; this file only turns it on.
{
  flake.modules.homeManager.cap = {
    imports = [ inputs.cap.homeManagerModules.default ];
    programs.cap.enable = true;
  };
}
