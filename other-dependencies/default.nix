{ pkgs, lib, inputs, ... }:

{
  # Use dynamic flake-based dependency management
  imports = [
    ./flake-dynamic.nix
  ];

  # Utility scripts for managing tools
  home.packages = [
    (pkgs.writeShellScriptBin "update-tool-hashes" ''
      echo "To update GitHub source hashes:"
      echo "1. Find the tool in tools-config.nix"
      echo "2. Run: nix-prefetch-url --unpack https://github.com/OWNER/REPO/archive/REV.tar.gz"
      echo "3. Update the sha256 in tools-config.nix"
      echo "4. Run: darwin-rebuild switch"
    '')
  ];

  # Environment variables
  home.sessionVariables = {
    UV_CACHE_DIR = "$HOME/.cache/uv";
  };
}
