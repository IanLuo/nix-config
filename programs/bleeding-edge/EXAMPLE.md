# Example: Adding a Bleeding-Edge Package

Let's walk through adding the latest GitHub CLI as a bleeding-edge package.

## Step 1: Get the Hash

```bash
# Get the hash for latest gh CLI
./scripts/bleeding-edge.sh hash https://github.com/cli/cli

# Output will be something like:
# sha256-AbC123DeF456...
```

## Step 2: Edit the Configuration

Edit `programs/bleeding-edge/default.nix` and uncomment/modify:

```nix
bleedingPackages = {
  # Add this new package:
  gh-latest = buildFromGit {
    owner = "cli";
    repo = "cli";
    rev = "v2.42.0";  # Replace with latest version
    sha256 = "sha256-AbC123DeF456...";  # Use hash from step 1
    
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
};
```

## Step 3: Test the Build

```bash
# Test that it builds
./scripts/bleeding-edge.sh test

# Or manually:
nix build .#darwinConfigurations.ianluo.system
```

## Step 4: Apply Changes

```bash
# Apply to your system
./scripts/rebuild.sh
```

## Step 5: Verify

```bash
# Check it's installed
which gh
gh --version

# Should show your bleeding-edge version
```

## Later: Update the Package

```bash
# 1. Check for new releases on GitHub
# 2. Get new hash:
./scripts/bleeding-edge.sh hash https://github.com/cli/cli v2.43.0

# 3. Update rev and sha256 in bleeding-edge/default.nix
# 4. Rebuild:
./scripts/rebuild.sh
```

This gives you the latest version of any software, even before it hits nixpkgs!
