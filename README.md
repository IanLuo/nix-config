# My Nix-based Dotfiles

A declarative and reproducible personal development environment for macOS and Linux, managed by Nix and Home Manager.

## Key Features

- **Cross-Platform**: Supports both macOS (Darwin) and Linux (NixOS).
- **Declarative**: All system and application configurations are defined as code.
- **Reproducible**: Nix Flakes ensure the same environment can be recreated anywhere.
- **Modular**: Configurations are broken down into logical units (programs, services, etc.).

## Structure

The repository is organized as follows:

```
.
├── flake.nix        # Main Nix Flake entry point
├── macos/           # macOS-specific configurations
├── linux/           # Linux-specific configurations
├── nixos/           # NixOS-specific configurations
├── programs/        # Application configurations
├── services/        # Background service configurations
└── scripts/         # Management and utility scripts
```

## Installation

1.  **Prerequisites**: Install Nix with Flakes support.
2.  **Clone**: Clone the repository.
3.  **Apply Configuration**:
    - For macOS: `nix run . -- switch --flake .#ian-mbp` (replace `ian-mbp` with your hostname)
    - For NixOS: `sudo nixos-rebuild switch --flake .#nixos-vm` (replace `nixos-vm` with your hostname)

## Usage

This repository includes several scripts in the `scripts/` directory to simplify common tasks:

- `update-all.sh`: Updates all flake inputs (unstable, stable, and home-manager) and applies the new configuration.
- `update-stable.sh`: Updates only the stable nixpkgs input and applies the new configuration.
- `update-unstable.sh`: Updates only the unstable nixpkgs input and applies the new configuration.
- `package-status.sh`: Shows the currently installed versions of packages defined in `bleeding-edge/`.
- `bleeding-edge.sh`: A script to manage bleeding-edge packages.
- `setup.sh`: A script for initial setup.
- `store.sh`: A script to perform operations on the nix store.

## Managed Software

This configuration manages the following software and services:

### Programs

- alacritty
- bleeding-edge
- emacs
- gitui
- kitty
- tmux
- vim
- zsh

### Services

- emacs
- lorri
- sketchybar
- skhd
- yabai