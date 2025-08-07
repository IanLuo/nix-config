# Solutions for Selective Package Upgrades

## Problem Statement
Current configuration ties all packages to a single nixpkgs version, making it impossible to upgrade individual packages without upgrading the entire system.

## Solution Strategies

### 1. Multiple Nixpkgs Inputs (Recommended)

Add multiple nixpkgs inputs to `flake.nix` for different update cadences:

```nix
inputs = {
  # Stable base system
  nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
  
  # Unstable for development tools
  nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  
  # Master branch for bleeding edge tools
  nixpkgs-master.url = "github:nixos/nixpkgs/master";
  
  # Specific package versions
  nixpkgs-nodejs.url = "github:nixos/nixpkgs/release-24.05";
};
```

**Benefits:**
- Mix stable and unstable packages
- Pin critical tools to known-good versions
- Upgrade development tools independently

### 2. Package-Specific Overlays

Create overlays to override specific package versions:

```nix
# overlays/nodejs.nix
final: prev: {
  nodejs = prev.nodejs_22; # Force specific Node.js version
  
  # Override from unstable
  neovim = inputs.nixpkgs-unstable.legacyPackages.${system}.neovim;
}
```

### 3. Flake Inputs for Specific Tools

Add individual package flakes as inputs:

```nix
inputs = {
  neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  rust-overlay.url = "github:oxalica/rust-overlay";
  emacs-overlay.url = "github:nix-community/emacs-overlay";
};
```

### 4. Package Categories Strategy

Organize packages by update frequency:

```nix
# programs/categories/
├── stable.nix       # Core system tools (git, curl, etc.)
├── development.nix  # Development tools (can be unstable)
├── experimental.nix # Latest versions for testing
└── pinned.nix      # Specifically pinned versions
```

### 5. Per-Host Package Management

Allow different hosts to use different package sets:

```nix
# Per-host configuration
darwinConfigurations.work-laptop = {
  # Use stable packages for work
  pkgs = stable-pkgs;
};

darwinConfigurations.personal = {
  # Use unstable packages for personal use
  pkgs = unstable-pkgs;
};
```

## Implementation Plan

### Phase 1: Add Multiple Nixpkgs Inputs
1. Modify `flake.nix` to include unstable nixpkgs
2. Create package selection logic
3. Test with a few packages

### Phase 2: Categorize Packages
1. Split `systemPackages.nix` by category
2. Assign packages to appropriate nixpkgs input
3. Update import structure

### Phase 3: Create Update Scripts
1. Script to update only unstable packages
2. Script to update only stable packages
3. Selective package update utilities

### Phase 4: Add Overlays
1. Create overlay directory structure
2. Implement package-specific overrides
3. Test overlay composition

## Quick Win: Mixed Nixpkgs Implementation

Here's a minimal change to start using both stable and unstable:

```nix
# In flake.nix inputs
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
  nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  # ... existing inputs
};

# In outputs
let
  stable-pkgs = import inputs.nixpkgs { ... };
  unstable-pkgs = import inputs.nixpkgs-unstable { ... };
  
  mixed-packages = with stable-pkgs; [
    # Stable core tools
    git gcc curl wget tree
  ] ++ [
    # Unstable development tools
    unstable-pkgs.neovim
    unstable-pkgs.nodejs
    unstable-pkgs.ripgrep
  ];
```

## Alternative: Nix Profiles

For some packages, consider using `nix profile`:

```bash
# Install latest version outside of flake
nix profile install nixpkgs#nodejs

# Upgrade individual package
nix profile upgrade nodejs
```

**Note:** This breaks declarative guarantees but provides flexibility.

## Recommendation

Start with **Multiple Nixpkgs Inputs** approach as it:
- Maintains declarative nature
- Provides immediate flexibility
- Allows gradual migration
- Keeps system reproducible

Would you like me to implement this solution?
