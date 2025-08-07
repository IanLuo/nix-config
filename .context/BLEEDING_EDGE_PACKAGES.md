# Bleeding-Edge Package Management

## Problem
Some software evolves very quickly and the latest versions may not be available even in nixpkgs-unstable. You need to reference specific git commits or build directly from source.

## Solutions

### 1. Direct Nixpkgs Git Reference

Reference a specific nixpkgs commit that has the package version you want:

```nix
# In flake.nix inputs
inputs = {
  # ... existing inputs
  nixpkgs-bleeding.url = "github:nixos/nixpkgs/commit-hash-here";
  
  # Or use a specific PR that adds/updates a package
  nixpkgs-pr-12345.url = "github:username/nixpkgs/branch-name";
};
```

### 2. Package-Specific Flake Inputs

Add the package's own flake as an input:

```nix
# In flake.nix inputs
inputs = {
  # ... existing inputs
  
  # Example: Latest Zig compiler
  zig.url = "github:mitchellh/zig-overlay";
  
  # Example: Latest Rust toolchain
  rust-overlay.url = "github:oxalica/rust-overlay";
  
  # Example: Latest Neovim nightly
  neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  
  # Example: Direct from a project's flake
  some-tool.url = "github:author/project";
  some-tool.inputs.nixpkgs.follows = "nixpkgs";
};
```

### 3. Build from Source with fetchFromGitHub

Create a custom package that builds directly from git:

```nix
# overlays/bleeding-edge.nix
final: prev: {
  my-bleeding-edge-tool = prev.stdenv.mkDerivation rec {
    pname = "my-tool";
    version = "git-${src.rev}";
    
    src = prev.fetchFromGitHub {
      owner = "author";
      repo = "project";
      rev = "specific-commit-hash";
      sha256 = "sha256-hash-here";  # Use lib.fakeSha256 first, then replace
    };
    
    buildInputs = with prev; [ /* dependencies */ ];
    
    buildPhase = ''
      # Build commands
    '';
    
    installPhase = ''
      # Install commands
    '';
  };
}
```

### 4. Using Specific Git Commits

Pin to exact commits for reproducibility:

```nix
# Example: Pin to specific commit
inputs.special-tool.url = "github:author/project/abc123def456";

# Example: Use latest from branch (not recommended for reproducibility)
inputs.special-tool.url = "github:author/project/main";

# Example: Use specific tag
inputs.special-tool.url = "github:author/project/v1.2.3";
```

## Implementation Examples

### Example 1: Latest Zig from Git
```nix
# In flake.nix
inputs.zig-bleeding = {
  url = "github:ziglang/zig";
  inputs.nixpkgs.follows = "nixpkgs";
};

# In packages
zig-latest = inputs.zig-bleeding.packages.${system}.zig;
```

### Example 2: Custom Package from Git
```nix
# overlays/custom-packages.nix
final: prev: {
  my-cli-tool = prev.buildGoModule rec {
    pname = "my-cli-tool";
    version = "0.0.0-${src.shortRev}";
    
    src = prev.fetchFromGitHub {
      owner = "author";
      repo = "my-cli-tool";
      rev = "main";  # or specific commit
      sha256 = prev.lib.fakeSha256;  # Replace with real hash
    };
    
    vendorSha256 = prev.lib.fakeSha256;  # For Go modules
  };
}
```

### Example 3: Using Package from Another Nixpkgs Branch
```nix
# Get a package from a different nixpkgs state
let
  bleeding-nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/commit-hash.tar.gz";
    sha256 = "sha256-hash-here";
  }) { inherit system; };
in {
  packages = [
    bleeding-nixpkgs.some-package
  ];
}
```

## Practical Workflow

### 1. Finding the Right Commit
```bash
# Find when a package was updated
nix-env -f https://github.com/nixos/nixpkgs/archive/master.tar.gz -qaP -A package-name

# Check nixpkgs GitHub for recent commits
# Look at package update PRs
```

### 2. Getting Hash for fetchFromGitHub
```bash
# Use nix-prefetch-url to get the sha256
nix-prefetch-url --unpack https://github.com/owner/repo/archive/commit.tar.gz

# Or use nix-prefetch-git
nix-prefetch-git https://github.com/owner/repo --rev commit-hash
```

### 3. Testing Before Committing
```bash
# Build specific package
nix build .#my-bleeding-edge-tool

# Test in temporary shell
nix shell .#my-bleeding-edge-tool

# Only commit to flake.lock when satisfied
```

## Update Strategies

### Automated Updates
```bash
# Script to update bleeding-edge inputs
#!/bin/bash
nix flake lock --update-input zig-bleeding
nix flake lock --update-input neovim-nightly
# Test build before applying
nix build .#darwinConfigurations.ianluo.system
```

### Manual Pin Updates
```nix
# Update the rev manually when you want newer version
inputs.my-tool.url = "github:author/project/new-commit-hash";
```

## Safety Considerations

### 1. Hash Verification
Always use proper sha256 hashes, never `lib.fakeSha256` in production

### 2. Binary Cache
Bleeding-edge packages likely won't be in binary cache, expect longer builds

### 3. Stability
Pin to specific commits rather than branches for reproducibility

### 4. Testing
Always test bleeding-edge packages in isolation before system-wide deployment

## Integration with Your Current Setup

I'll show you how to add this to your existing mixed-package system...
