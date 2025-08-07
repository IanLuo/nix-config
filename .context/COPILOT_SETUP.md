# Enabling GitHub Copilot (Unfree Package)

## Problem
GitHub Copilot plugin (`copilot-vim`) is marked as unfree in nixpkgs and requires special configuration to enable.

## Solution

### Option 1: Enable Unfree Globally (Recommended)

Your `flake.nix` already has `config.allowUnfree = true` in the nixpkgs imports, so this should work. Let's add the Copilot plugin:

```nix
# Add to programs/vim/default.nix plugins list:
copilot-vim
```

### Option 2: Enable Specific Unfree Packages Only

If you want to be more selective, you can specify only certain unfree packages:

```nix
# In flake.nix, modify the nixpkgs imports:
darwinPkgs = import inputs.nixpkgs {
  system = myDarwin;
  config = {
    allowUnfree = true;
    # Or be more specific:
    # allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    #   "copilot-vim"
    # ];
  };
};
```

## Complete Setup Steps

### 1. Add Copilot Plugin to Your Config

```bash
# Edit programs/vim/default.nix and add:
# copilot-vim  # Add this to your plugins list
```

### 2. Create Copilot Configuration

```lua
-- Create programs/vim/config/lua/plugins/copilot.lua:
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- Custom keybindings for Copilot
vim.keymap.set('i', '<C-l>', 'copilot#Accept("")', {
  expr = true,
  replace_keycodes = false,
  silent = true
})

-- Optional: Disable Copilot for certain filetypes
vim.g.copilot_filetypes = {
  ["*"] = false,
  ["javascript"] = true,
  ["typescript"] = true,
  ["lua"] = true,
  ["rust"] = true,
  ["c"] = true,
  ["c++"] = true,
  ["go"] = true,
  ["python"] = true,
}
```

### 3. Add to init.lua

```lua
-- Add to programs/vim/config/init.lua:
require("plugins.copilot")
```

### 4. Setup GitHub Authentication

After applying the config, you'll need to authenticate:

```bash
# In Neovim, run:
:Copilot setup
```

This will give you a device code to enter on GitHub.

## Testing the Configuration

### 1. Build and Apply

```bash
# Test the configuration builds
nix flake check

# Apply the changes
./scripts/rebuild.sh
```

### 2. Verify Copilot Works

```bash
# Open Neovim and check Copilot status
nvim
:Copilot status
```

### 3. Test Suggestions

1. Create a new file: `test.py`
2. Start typing a function:
   ```python
   def fibonacci(n):
   ```
3. Copilot should show suggestions
4. Press `Ctrl+L` to accept suggestions

## Alternative: Use Bleeding-Edge for Latest Copilot

If you want the very latest version of Copilot:

```nix
# In programs/bleeding-edge/default.nix:
copilot-latest = buildFromGit {
  owner = "github";
  repo = "copilot.vim";
  rev = "main";  # or specific version
  sha256 = "sha256-...";  # Get with nix-prefetch-git
  
  pname = "copilot-vim";
  version = "bleeding";
  
  installPhase = ''
    mkdir -p $out
    cp -r . $out/
  '';
};
```

## Troubleshooting

### If Copilot Plugin Fails to Load

1. **Check unfree is enabled**: Verify your nixpkgs config allows unfree
2. **Rebuild completely**: Sometimes a full rebuild is needed
3. **Check authentication**: Run `:Copilot auth` in Neovim

### If Suggestions Don't Appear

1. **Check status**: `:Copilot status`  
2. **Enable for filetype**: Add to `copilot_filetypes`
3. **Network issues**: Copilot needs internet access

## Why This Approach is Better

✅ **Declarative**: All configuration in Nix files  
✅ **Reproducible**: Same setup across machines  
✅ **Version controlled**: Track Copilot config changes  
✅ **Integrated**: Works with your existing Neovim setup

Your unfree packages are already enabled in the flake.nix, so you should be able to add `copilot-vim` directly to your plugin list!
