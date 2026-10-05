{ ... }:
# godot — the engine for the twilight project (a 3D atmospheric game).
#
# Source: the official macOS release, installed app-bundle style at
# /Applications/Godot.app. Why not nixpkgs:
#   - nixpkgs' `godot` targets Linux only (x86_64-linux, aarch64-linux,
#     i686-linux), so there is no darwin build to select at all;
#   - the version the registry carries is 4.7.x, while the project forbids
#     anything past 4.5.x — 4.6 broke glTF import (vertex colouring and
#     skeletal rigging).
# Upgrade path: put the next 4.5.x from the same official release page in
# /Applications/Godot.app. Do not drift this to 4.6+.
{
  flake.modules.homeManager.godot = { config, ... }: {
    # Exposed on PATH via ~/.local/bin, which is already ahead of /usr/bin.
    # A symlink, not a copy: the bundle is ~300MB and code-signed, so it must
    # not be dragged into the store.
    home.file.".local/bin/godot".source =
      config.lib.file.mkOutOfStoreSymlink "/Applications/Godot.app/Contents/MacOS/Godot";
  };
}
