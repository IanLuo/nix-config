# Other Dependencies Management System

Modern, declarative management for Python and Node.js global tools through Nix flakes and Home Manager.

## Features

- **Flake-based Architecture**: Dynamic tool building with support for nixpkgs, GitHub, and npm sources
- **Version Pinning**: Exact version control with hash verification for reproducibility
- **Mixed Sources**: Support for nixpkgs packages, GitHub repositories, and npm packages
- **Automatic SSL Certificates**: Built-in SSL certificate handling for npm registry access
- **Dynamic Building**: Tools are built on-demand based on configuration

## Structure

- `tools-config.nix` - Central tool configuration with sources and versions
- `flake-dynamic.nix` - Dynamic tool building engine with multi-source support
- `default.nix` - Main module that imports flake-dynamic and provides utilities

## Tool Sources

- **nixpkgs**: Pre-built packages from the Nix package repository
- **GitHub**: Direct builds from GitHub repositories with commit pinning
- **npm**: npm packages with SSL certificate support

## Usage

### Automatic Installation

Dependencies are **automatically built and installed** when you run:

```bash
./scripts/setup.sh
# or
darwin-rebuild switch
```

The system uses Home Manager to build tools dynamically based on the configuration in `tools-config.nix`.

### Adding Tools

#### Any Tool Type

1. Edit `other-dependencies/tools-config.nix` and add your tool configuration
2. Run `darwin-rebuild switch` and tools will be built and installed automatically

#### Examples

**From nixpkgs:**
```nix
python = {
  black = {
    source = "nixpkgs";
    constraint = ">=24.0.0,<26.0.0";
  };
};
```

**From npm:**
```nix
nodejs = {
  gemini-cli = {
    source = "nixpkgs";  # Use nixpkgs version for stability
  };
};
```

**From GitHub:**
```nix
rust = {
  custom-tool = {
    source = "github";
    owner = "user";
    repo = "tool";
    rev = "abc123";
    sha256 = "sha256-...";
  };
};
```

### Tool Information

List all configured tools and their status:

```bash
list-flake-tools
```

This shows:
- Tool name and category
- Source type (nixpkgs/github/npm)
- Version information
- Availability status