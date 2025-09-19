# Ian's Declarative Darwin & NixOS Configuration

This repository contains the complete declarative configuration for my personal development environment across macOS (Darwin) and NixOS, managed using [Nix Flakes](https://nixos.wiki/wiki/Flakes).

## Overview

The primary goal of this project is to create a consistent, reproducible, and automated development environment. By defining all system and application settings as code, I can easily set up a new machine or replicate my environment anywhere.

## Core Features

- **Declarative**: The entire system state, from packages to dotfiles, is defined in `.nix` files. No manual configuration is needed.
- **Reproducible**: Nix Flakes lock all dependencies, including `nixpkgs`, ensuring that the build is bit-for-bit identical every time.
- **Cross-Platform**: A single codebase manages configurations for:
    - macOS (via `nix-darwin`)
    - NixOS
    - Other Linux distributions (via `home-manager`)
- **Extensible**: Adding a new application or service is as simple as adding a new Nix module to the `programs` or `services` directory.

## Directory Structure

A high-level overview of the repository's structure:

- `flake.nix`: The central entry point. It defines all dependencies (`inputs`) and builds the final system configurations (`outputs`) for each host.
- `macos/`: Contains all macOS-specific configurations, imported by `nix-darwin`.
- `nixos/`: The `configuration.nix` for NixOS hosts.
- `linux/`: A shared `home.nix` for all Linux-based systems (both NixOS and others).
- `programs/`: Manages shared, user-level application configurations for tools like:
    - **Editors:** Neovim, Emacs
    - **Terminals:** Alacritty, Kitty
    - **Shell:** Zsh, Tmux
    - ...and many others.
- `services/`: Manages background services. This includes macOS-specific window management (`yabai`, `skhd`, `sketchybar`) and general services like `lorri`.
- `scripts/`: Helper scripts for common maintenance tasks.

## Getting Started

### Prerequisites

- [Nix](https://nixos.org/download.html) must be installed.
- [Flakes](https://nixos.wiki/wiki/Flakes#Enable_flakes) must be enabled.

### Installation

1. Clone this repository.
2. Run the appropriate build command for your platform from the repository root:

    - **For macOS:**
        ```bash
        nix run nix-darwin -- switch --flake .#ianluo
        ```
        *(Replace `ianluo` with the desired username/configuration defined in `flake.nix`)*

    - **For NixOS:**
        ```bash
        sudo nixos-rebuild switch --flake .#nixos-vm
        ```
        *(Replace `nixos-vm` with the desired hostname defined in `flake.nix`)*

    - **For other Linux distributions:**
        ```bash
        nix run home-manager -- switch --flake .#ian-linux-dev
        ```
        *(Replace `ian-linux-dev` with the desired username defined in `flake.nix`)*

## Common Commands

The `scripts/` directory contains several useful scripts for managing the environment:

- `./scripts/update-all.sh`: Updates all flake inputs (`nix flake update`) and rebuilds the system.
- `./scripts/package-status.sh`: Shows the status of bleeding-edge packages.
- `./scripts/store.sh`: Provides commands for garbage collection and store optimization.
