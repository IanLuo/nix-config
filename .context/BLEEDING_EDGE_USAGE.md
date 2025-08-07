# Bleeding-Edge Packages Usage Guide

## How It Works

Your bleeding-edge packages are defined in `programs/bleeding-edge/default.nix` and automatically included in your system packages. This approach keeps the package definitions co-located with their configurations, making maintenance easier.

## Adding a New Bleeding-Edge Package

### Step 1: Choose Your Approach

#### Option A: Get Latest from Nixpkgs Master
When you want the latest version from nixpkgs (before it reaches stable/unstable):

```nix
# In programs/bleeding-edge/default.nix, uncomment and modify:
my-package-latest = fetchNixpkgsPackage {
  commit = "master";  # or specific commit hash
  package = "my-package";
};
```

#### Option B: Build Directly from Git
When the software isn't in nixpkgs yet or you want bleeding-edge commits:

```nix
# In programs/bleeding-edge/default.nix, uncomment and modify:
my-tool = buildFromGit {
  owner = "author";
  repo = "project";
  rev = "main";  # or specific commit/tag
  sha256 = "sha256-HASH-HERE";  # Get this with nix-prefetch-git
  
  pname = "my-tool";
  version = "bleeding";
  
  nativeBuildInputs = with pkgs; [ /* build dependencies */ ];
  buildInputs = with pkgs; [ /* runtime dependencies */ ];
  
  buildPhase = ''
    # Build commands here
  '';
  
  installPhase = ''
    # Install commands here
  '';
};
```

## Practical Examples

Let me show you real examples you can copy and paste:

### Example 1: Latest GitHub CLI

```nix
# Add this to bleedingPackages in programs/bleeding-edge/default.nix:
gh-latest = buildFromGit {
  owner = "cli";
  repo = "cli";
  rev = "v2.42.0";  # Replace with latest version
  sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # Replace with real hash
  
  pname = "gh";
  version = "2.42.0-bleeding";
  
  nativeBuildInputs = with pkgs; [ go makeWrapper ];
  
  buildPhase = ''
    export HOME=$TMPDIR
    make build
  '';
  
  installPhase = ''
    make install prefix=$out
  '';
};
```

### Example 2: Latest Bun Runtime

```nix
# Add this to bleedingPackages:
bun-latest = fetchNixpkgsPackage {
  commit = "master";  # Get latest bun from nixpkgs master
  package = "bun";
};
```

### Example 3: Custom Rust Tool

```nix
# Add this to bleedingPackages:
my-rust-cli = buildFromGit {
  owner = "BurntSushi";
  repo = "ripgrep";
  rev = "14.1.0";  # Replace with version you want
  sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  
  pname = "rg-bleeding";
  
  nativeBuildInputs = with pkgs; [ rustc cargo ];
  
  buildPhase = ''
    cargo build --release
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    cp target/release/rg $out/bin/rg-bleeding
  '';
};
```

## Step-by-Step: Adding a Package

### 1. Get the SHA256 Hash

```bash
# For GitHub repos:
nix-prefetch-git https://github.com/owner/repo --rev commit-or-tag

# This will output something like:
# {
#   "url": "https://github.com/owner/repo",
#   "rev": "abc123...",
#   "date": "2024-01-01T00:00:00+00:00",
#   "path": "/nix/store/...",
#   "sha256": "sha256-RealHashHere...",
#   "fetchLFS": false,
#   "fetchSubmodules": false,
#   "deepClone": false,
#   "leaveDotGit": false
# }
```

### 2. Add Package Definition

Edit `programs/bleeding-edge/default.nix` and uncomment/modify one of the examples:

```nix
bleedingPackages = {
  # Your new package:
  my-new-tool = buildFromGit {
    owner = "author";
    repo = "project";
    rev = "v1.0.0";
    sha256 = "sha256-YourRealHashHere...";
    
    pname = "my-new-tool";
    
    # Add build dependencies
    nativeBuildInputs = with pkgs; [ go ]; # or rustc, nodejs, python3, etc.
    
    # Define build process
    buildPhase = ''
      make build
    '';
    
    installPhase = ''
      make install PREFIX=$out
    '';
  };
  
  # Keep existing packages...
};
```

### 3. Test and Apply

```bash
# Test the package builds
nix build .#darwinConfigurations.ianluo.system

# If it builds successfully, apply:
./scripts/rebuild.sh
```

### 4. Verify Installation

```bash
# Check if your tool is available
which my-new-tool

# Test it works
my-new-tool --version
```

## Upgrading Bleeding-Edge Packages

### Method 1: Update Git Reference

```bash
# 1. Find the latest commit/tag
git ls-remote https://github.com/owner/repo

# 2. Get new hash
nix-prefetch-git https://github.com/owner/repo --rev NEW_COMMIT

# 3. Update in programs/bleeding-edge/default.nix:
#    rev = "NEW_COMMIT";
#    sha256 = "sha256-NEW_HASH";

# 4. Rebuild
./scripts/rebuild.sh
```

### Method 2: Update Nixpkgs Reference

```bash
# For packages using fetchNixpkgsPackage, they automatically update
# when you update nixpkgs:
./scripts/update-stable.sh  # or update-unstable.sh
./scripts/rebuild.sh
```

## Troubleshooting

### Build Failures

```bash
# Get detailed build logs
nix build .#darwinConfigurations.ianluo.system --show-trace --print-build-logs

# Test individual package
nix-build -E '
  let pkgs = import <nixpkgs> {};
  in pkgs.callPackage ./programs/bleeding-edge/default.nix {}
' -A enabledPackages.my-tool
```

### Hash Mismatches

```bash
# If you get "hash mismatch" error, the real hash is shown in the error
# Copy it and update your configuration
```

### Missing Dependencies

```bash
# Check what dependencies a project needs by looking at:
# - README.md 
# - Makefile
# - package.json (for Node.js)
# - Cargo.toml (for Rust)  
# - go.mod (for Go)

# Add them to nativeBuildInputs or buildInputs as needed
```

## Real-World Workflow

### Weekly Updates

```bash
# 1. Check for new releases on GitHub
# 2. Update rev and sha256 in bleeding-edge/default.nix
# 3. Test and apply:
nix build .#darwinConfigurations.ianluo.system
./scripts/rebuild.sh
```

### Adding New Tools

```bash
# 1. Find the tool's GitHub repo
# 2. Check how it builds (Make, Cargo, Go, npm, etc.)
# 3. Add definition to bleeding-edge/default.nix
# 4. Test and iterate until it works
```

Your bleeding-edge packages are now managed alongside your stable and unstable packages, giving you complete control over your development environment!
