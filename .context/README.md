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
- **Nixpkgs**: Version 24.11 (stable release)

## Directory Structure

```
.
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Locked input versions
├── macos/                       # macOS-specific configurations
│   ├── default.nix
│   └── home-manager/
├── linux/                      # Linux home-manager configs
├── nixos/                       # NixOS system configurations
├── programs/                    # Application configurations
│   ├── vim/                     # Neovim setup with 40+ plugins
│   ├── zsh/                     # Zsh with Powerlevel10k
│   ├── tmux/
│   ├── alacritty/
│   ├── kitty/
│   └── systemPackages.nix      # System-wide packages
├── services/                    # System services
│   ├── yabai/                   # Window manager (macOS)
│   ├── skhd/                    # Keyboard shortcuts
│   └── sketchybar/              # Status bar
├── misc/                        # Miscellaneous configs
└── scripts/                     # Utility scripts
    ├── install.sh
    ├── ianluo.switch.sh
    └── ian.linux.switch.sh
```

## Users & Hosts

### macOS
- **User**: `ianluo`
- **Hosts**: `CDU-L737HCJ9FJ`, `ianluo`

### Linux
- **Users**: `ian`, `nixos`

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

### Rebuild System (macOS)
```bash
./ianluo.switch.sh
```

### Rebuild System (Linux)
```bash
./ian.linux.switch.sh
```

### Update Nixpkgs
```bash
./latest_nixpkgs.sh
```

## Known Issues

1. **Package Upgrade Problem**: Cannot upgrade individual packages without upgrading entire nixpkgs
2. **Dependency Management**: All packages are tied to nixpkgs version
3. **Update Frequency**: System-wide updates can be disruptive

See `SOLUTIONS.md` for approaches to address these issues.
