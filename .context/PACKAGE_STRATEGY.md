# Package Management Strategy

## Current Package Analysis

Based on your `systemPackages.nix`, here's how we can categorize packages for selective upgrades:

### Core System Packages (Keep Stable)
These should use stable nixpkgs for reliability:

```nix
stable-packages = [
  git              # Version control - stability important
  gcc              # Compiler - compatibility critical
  curl wget        # Network tools - stability over features
  tree             # File listing - rarely changes
  zsh              # Shell - stability important
  tmux             # Terminal multiplexer - stability over features
];
```

### Development Tools (Can Use Unstable)
These benefit from latest versions and features:

```nix
unstable-packages = [
  nodejs           # Rapid development, new features
  nixd             # Nix language server - latest fixes
  ripgrep fd       # Search tools - performance improvements
  podman           # Container runtime - latest features
  nix-index        # Package search - latest package data
  nix-tree         # Nix visualization - improvements
  nix-du           # Nix disk usage - latest features
];
```

### macOS-Specific (Stable Unless Needed)
```nix
darwin-packages = [
  m-cli            # Stable - CLI for macOS
  iterm2           # Stable - terminal emulator
  discord          # Could be unstable - latest features
  raycast          # Could be unstable - latest features
  cocoapods        # Stable - iOS development
];
```

### Editor/IDE Tools (Mixed Strategy)
```nix
# Base editor - stable
programs.neovim.package = stable-pkgs.neovim;

# Plugins can be from unstable for latest features
plugins = with unstable-pkgs.vimPlugins; [
  copilot-vim
  nvim-tree-lua
  telescope-nvim
  # ...
];
```

## Implementation Strategy

### 1. Immediate Quick Fix
Add unstable nixpkgs to your flake without major restructuring:

```nix
# In flake.nix inputs section
nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
nixpkgs-unstable.inputs.nixpkgs.follows = "nixpkgs";
```

### 2. Selective Package Upgrading
Create a new file `programs/mixed-packages.nix`:

```nix
{
  stable-pkgs,
  unstable-pkgs,
  system,
  ...
}: {
  stable = with stable-pkgs; [
    git gcc curl wget tree zsh tmux
    # Core system tools that should be stable
  ];
  
  unstable = with unstable-pkgs; [
    nodejs nixd ripgrep fd nix-index
    # Development tools that benefit from latest versions
  ];
  
  # Allow per-package overrides
  overrides = {
    # Use specific version of nodejs
    nodejs = unstable-pkgs.nodejs_22;
    
    # Use bleeding edge neovim
    neovim = unstable-pkgs.neovim;
  };
}
```

### 3. Update Scripts
Create selective update scripts:

```bash
# scripts/update-stable.sh
nix flake lock --update-input nixpkgs

# scripts/update-unstable.sh  
nix flake lock --update-input nixpkgs-unstable

# scripts/update-package.sh
# Usage: ./update-package.sh nodejs
PACKAGE=$1
nix flake lock --update-input nixpkgs-${PACKAGE} 2>/dev/null || 
nix flake lock --update-input nixpkgs-unstable
```

## Migration Path

### Week 1: Add Unstable Input
- Add `nixpkgs-unstable` to flake inputs
- Test with 2-3 development packages
- Verify system still builds

### Week 2: Categorize Packages
- Move development tools to unstable
- Keep core system on stable
- Test individual updates

### Week 3: Add Overlays (Optional)
- Create overlays for specific version pins
- Handle edge cases and conflicts

### Week 4: Automation
- Create update scripts
- Add package category documentation
- Test full workflow

## Benefits After Migration

1. **Selective Updates**: Upgrade development tools without touching system
2. **Stability**: Keep core system on tested stable packages  
3. **Latest Features**: Get newest development tool features
4. **Flexibility**: Pin specific packages to known-good versions
5. **Rollback**: Easy to revert individual package updates

## Example Usage After Implementation

```bash
# Update only development tools
./scripts/update-unstable.sh
darwin-rebuild switch --flake .

# Update only stable system packages  
./scripts/update-stable.sh
darwin-rebuild switch --flake .

# Pin nodejs to specific version
echo 'nodejs = nixpkgs-stable.nodejs_20;' >> overlays/pins.nix
```

Would you like me to start implementing this solution by modifying your flake.nix?
