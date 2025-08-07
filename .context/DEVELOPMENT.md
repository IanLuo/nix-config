# Development Guide

## Project Structure Best Practices

### Module Organization
```
programs/
├── categories/           # NEW: Organize by update frequency
│   ├── stable.nix       # Core system packages
│   ├── development.nix  # Development tools
│   └── experimental.nix # Latest/testing packages
├── applications/         # Individual app configurations
│   ├── vim/
│   ├── zsh/
│   └── tmux/
└── overlays/            # NEW: Package version overrides
    ├── nodejs.nix
    └── neovim.nix
```

### Configuration Patterns

#### 1. Conditional Loading
```nix
# Load different configs based on hostname or user
imports = 
  if (config.networking.hostName == "work-laptop") 
  then [ ./work-specific.nix ]
  else [ ./personal.nix ];
```

#### 2. Feature Flags
```nix
# Enable/disable features via variables
let
  enableGaming = false;
  enableWork = true;
in {
  home.packages = []
    ++ lib.optionals enableWork [ slack zoom ]
    ++ lib.optionals enableGaming [ steam discord ];
}
```

#### 3. Version Pinning
```nix
# Pin specific tool versions
let
  pinnedNodeJS = "20.11.0";
  pinnedPython = "3.11";
in {
  # Use pinned versions in overlays
}
```

## Testing Strategy

### 1. Dry Run Changes
```bash
# Test configuration without applying
nix build .#darwinConfigurations.ianluo.system
```

### 2. Incremental Testing
```bash
# Test individual modules
nix-instantiate --eval programs/vim/default.nix
```

### 3. Rollback Strategy
```bash
# List generations
darwin-rebuild --list-generations

# Rollback to previous generation
darwin-rebuild rollback
```

## Development Workflow

### 1. Feature Branch Development
```bash
git checkout -b feature/mixed-nixpkgs
# Make changes
nix build .#darwinConfigurations.ianluo.system
# Test changes
darwin-rebuild switch --flake .
```

### 2. Configuration Validation
```bash
# Check flake syntax
nix flake check

# Show flake outputs
nix flake show
```

### 3. Dependency Management
```bash
# Update specific input
nix flake lock --update-input nixpkgs-unstable

# Show dependency tree
nix-tree --derivation $(nix build .#darwinConfigurations.ianluo.system)
```

## Debugging Common Issues

### 1. Build Failures
```bash
# Verbose build output
nix build --show-trace --print-build-logs

# Check for conflicts
nix-env --query --available nodejs
```

### 2. Package Conflicts
```bash
# Check what's providing a package
nix-locate bin/node

# List installed packages
nix-env --query --installed
```

### 3. Configuration Errors
```bash
# Validate Nix syntax
nix-instantiate --parse flake.nix

# Check home-manager config
home-manager build --flake .
```

## Performance Optimization

### 1. Build Caching
```nix
# Add binary caches
nix.settings = {
  substituters = [
    "https://cache.nixos.org/"
    "https://nix-community.cachix.org"
  ];
  trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
};
```

### 2. Evaluation Caching
```bash
# Enable flake evaluation caching
nix.settings.eval-cache = true;
```

### 3. Garbage Collection
```bash
# Regular cleanup
nix-collect-garbage --delete-older-than 30d
```

## Security Considerations

### 1. Package Sources
- Only use trusted nixpkgs branches
- Verify package signatures when available
- Pin critical packages to known-good versions

### 2. Secrets Management
```nix
# Never put secrets in nix store
# Use external secret management
services.gpg-agent.enable = true;
```

### 3. Binary Cache Verification
```nix
nix.settings.require-sigs = true;
nix.settings.trusted-users = [ "root" "@wheel" ];
```

## Maintenance Schedule

### Weekly
- Update unstable development tools
- Review new package versions
- Test configuration changes

### Monthly  
- Update stable packages
- Clean old generations
- Review security advisories

### Quarterly
- Major nixpkgs version updates
- Configuration refactoring
- Backup configuration

## Troubleshooting Checklist

1. **Build fails**: Check `--show-trace` output
2. **Package not found**: Verify nixpkgs input version
3. **Service won't start**: Check systemd logs
4. **Configuration ignored**: Verify module imports
5. **Performance issues**: Check evaluation time with `nix eval --show-trace`

## Contributing Guidelines

### Commit Messages
```
feat: add unstable nixpkgs for development tools
fix: resolve nodejs version conflict  
docs: update package categorization strategy
refactor: reorganize program modules
```

### Code Style
- Use 2-space indentation
- Group related packages together
- Comment complex logic
- Prefer explicit over implicit imports

### Testing Requirements
- All changes must build successfully
- Test on both personal and work configurations
- Document breaking changes
- Update `.context/` documentation
