# Darwin Nix Configuration

## Overview
This is a declarative system configuration project using Nix Flakes that manages development environments across multiple platforms (macOS, Linux, NixOS). It provides a reproducible development setup with consistent tooling across different machines.

## Architecture

### Multi-Platform Support
- **macOS** (via nix-darwin): Apple Silicon Macs (`aarch64-darwin`)
- **Linux** (via home-manager): ARM64 Linux systems (`aarch64-linux`)  
- **NixOS**: Full system configuration with i3 window manager

### Key Components
- **Nix Flakes**: Modern Nix configuration with `flake.nix` as entry point
- **Home Manager**: User environment management
- **nix-darwin**: macOS-specific Nix integration
- **Checks**: Flake checks plus a NixOS VM smoke test

## Directory Structure

```
.
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Locked input versions
├── hosts/                       # Host entrypoints
│   ├── darwin/
│   ├── home/
│   └── nixos/
├── modules/                     # Shared and platform modules
│   ├── darwin/
│   ├── linux/
│   ├── nixos/
│   └── shared/
├── nixos/                       # NixOS system configurations
├── programs/                    # Application configurations
│   ├── vim/                     # Neovim setup with 40+ plugins
│   ├── zsh/                     # Zsh with Powerlevel10k
│   └── bleeding-edge/
├── services/                    # System services
│   ├── yabai/                   # Window manager (macOS)
│   ├── skhd/                    # Keyboard shortcuts
│   └── sketchybar/              # Status bar
├── checks/                      # Flake checks and test definitions
└── scripts/                     # Utility scripts
    ├── setup.sh
    ├── rebuild.sh
    └── update-*.sh
```

## Users & Hosts

### Active Outputs
- Darwin: `darwinConfigurations.ianluo`
- Linux HM: `homeConfigurations.ian-linux-dev`
- NixOS: `nixosConfigurations.nixos-vm`

## Key Features

### Development Environment
- **Neovim**: Extensively configured with LSP, Treesitter, GitHub Copilot
- **Terminal**: Zsh + Powerlevel10k + Tmux
- **Version Control**: Git with GitUI
- **Languages**: Support for 20+ programming languages

### System Management
- **Window Management**: Yabai + SKHD (macOS)
- **Desktop Environment**: i3 + XFCE (NixOS)
- **Package Management**: Declarative via Nix

### Tools & Utilities
- Development: `git`, `gcc`, `nodejs`, `podman`
- Utilities: `ripgrep`, `fd`, `tree`, `curl`, `wget`
- Nix tools: `nixd`, `nix-index`, `nix-tree`

## Common Operations

### Initial Setup
```bash
./install.sh
```

### Rebuild System
```bash
./scripts/rebuild.sh
```

### Validate
```bash
nix flake check --all-systems
```

## Known Issues

1. Linux and NixOS builds still need a Linux builder for full end-to-end runtime verification on a Darwin machine
2. The current package grouping separates intent, but both grouped package sets are still sourced from `nixpkgs`
3. Some older `.context/` notes describe superseded experiments rather than the active final layout

See `SOLUTIONS.md` for approaches to address these issues.
