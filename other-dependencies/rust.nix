{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Rust toolchain
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer   # LSP server for Rust
  ];

  # Create a minimal global tools Cargo.toml
  home.file.".config/cargo-global-tools/Cargo.toml".text = ''
    [package]
    name = "global-tools"
    version = "0.1.0"
    edition = "2021"

    [lib]
    name = "global_tools"
    path = "src/lib.rs"
    
    # Add your global tools here:
    [dependencies]
    # Example: cargo-edit = "0.12"
  '';

  home.file.".config/cargo-global-tools/src/lib.rs".text = "";

  # Basic Cargo configuration
  home.file.".cargo/config.toml".text = ''
    [term]
    color = "auto"
  '';

  # Environment variables for Rust/Cargo
  home.sessionVariables = {
    CARGO_HOME = "$HOME/.cargo";
    RUST_BACKTRACE = "1";
  };
}
