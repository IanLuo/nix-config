{ pkgs, ... }:

{
  # Import all dependency manager configurations
  imports = [
    ./python.nix
    ./nodejs.nix
    ./rust.nix
  ];

  home.packages = [
    (pkgs.writeShellScriptBin "install-global-deps" ''
      #!/usr/bin/env bash
      set -euo pipefail
      echo "Installing Python global tools..."
      uv sync --pyproject-toml ~/.config/uv-global-tools/pyproject.toml
      echo "Installing Node.js global tools..."
      npm install --prefix ~/.config/npm-global-tools
      echo "Installing Rust global tools..."
      cargo install --path ~/.config/cargo-global-tools
    '')
  ];

  # Consolidated environment variables
  home.sessionVariables = {
    # Add all dependency manager paths to PATH
    PATH = "$HOME/.local/share/uv/tools/bin:$HOME/.npm-global/bin:$HOME/.cargo/bin:$PATH";
  };
}
