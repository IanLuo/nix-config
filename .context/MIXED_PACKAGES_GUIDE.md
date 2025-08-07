# Mixed Package System Usage Guide

## What Changed

Your Nix configuration now supports **selective package upgrades** using both stable and unstable nixpkgs channels. This solves your original problem of not being able to upgrade individual packages without upgrading everything.

## How It Works

### Two Nixpkgs Channels
- **Stable** (`nixpkgs`): Core system tools that need stability
- **Unstable** (`nixpkgs-unstable`): Development tools that benefit from latest features

### Package Categories

#### Stable Packages (24.11 release)
```nix
stablePackages = [
  git gcc curl wget tree       # Core utilities
  zsh tmux                     # Shell/terminal tools
  direnv nix-direnv           # Environment management
  nerdfonts manix             # Fonts and documentation
];
```

#### Unstable Packages (rolling release)
```nix
unstablePackages = [
  nodejs nixd                 # Development tools
  ripgrep fd                  # Search utilities  
  podman                      # Containers
  nix-index nix-tree nix-du   # Nix utilities
  dbeaver-bin element-desktop # Applications
];
```

## Usage Examples

### Update Only Development Tools
```bash
./scripts/update-unstable.sh  # Updates nodejs, nixd, ripgrep, etc.
./scripts/rebuild.sh          # Apply changes
```

### Update Only System Packages  
```bash
./scripts/update-stable.sh    # Updates git, gcc, shell, etc.
./scripts/rebuild.sh          # Apply changes
```

### Update Everything
```bash
./scripts/update-all.sh       # Updates all inputs
./scripts/rebuild.sh          # Apply changes
```

### Check Package Status
```bash
./scripts/package-status.sh   # Shows current versions and options
```

## Real-World Scenarios

### Scenario 1: Latest Node.js
```bash
# Get latest Node.js without touching system packages
./scripts/update-unstable.sh
./scripts/rebuild.sh
```

### Scenario 2: System Maintenance
```bash
# Update stable system tools monthly
./scripts/update-stable.sh
./scripts/rebuild.sh
```

### Scenario 3: New Development Tools
```bash
# Get latest development tools weekly
./scripts/update-unstable.sh
./scripts/rebuild.sh
```

## Migration Benefits

### Before (Single Channel)
❌ **Problem**: All packages tied to one nixpkgs version
❌ **Issue**: Can't upgrade Node.js without upgrading everything  
❌ **Risk**: System-wide updates can break workflow

### After (Mixed Channels)
✅ **Solution**: Packages from appropriate channels
✅ **Flexibility**: Upgrade development tools independently
✅ **Stability**: Core system stays on stable packages
✅ **Control**: Choose update frequency per category

## Advanced Usage

### Pin Specific Package Version
If you need to pin a specific package to a particular version, you can:

1. **Create overlay** (recommended):
```nix
# overlays/pins.nix
final: prev: {
  nodejs = prev.nodejs_20; # Pin to Node.js 20
}
```

2. **Use different nixpkgs input**:
```nix
inputs.nixpkgs-nodejs20.url = "github:nixos/nixpkgs/commit-with-nodejs20";
```

### Check Package Versions
```bash
# See what version you'll get
nix eval nixpkgs#nodejs.version        # Stable
nix eval nixpkgs-unstable#nodejs.version  # Unstable
```

### Rollback Changes
```bash
# If update breaks something
darwin-rebuild rollback

# Or revert specific input
git checkout HEAD~1 flake.lock
./scripts/rebuild.sh
```

## File Changes Made

### Modified Files
- `flake.nix`: Added nixpkgs-unstable input
- `programs/systemPackages.nix`: Split packages by stability needs

### New Files  
- `scripts/update-stable.sh`: Update stable packages only
- `scripts/update-unstable.sh`: Update development tools only
- `scripts/update-all.sh`: Update everything
- `scripts/rebuild.sh`: Smart rebuild script
- `scripts/package-status.sh`: Show current status
- `.context/`: Documentation and guides

## Testing the Changes

### 1. Verify Configuration
```bash
nix flake check                    # Verify syntax
nix build .#darwinConfigurations.ianluo.system  # Test build
```

### 2. Apply Changes
```bash
./scripts/rebuild.sh              # Apply new mixed system
```

### 3. Test Selective Updates
```bash
./scripts/package-status.sh       # Check current state
./scripts/update-unstable.sh      # Update dev tools only
./scripts/rebuild.sh              # Apply updates
```

## Next Steps

1. **Test the new system**: Run the rebuild and verify it works
2. **Try selective updates**: Test updating only unstable packages
3. **Customize categories**: Move packages between stable/unstable as needed
4. **Add more channels**: Consider adding specific inputs for tools you pin often

The mixed package system gives you the flexibility you needed while maintaining the declarative benefits of Nix!
