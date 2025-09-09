# Other Dependencies Management System

Simple, declarative management for Python, Node.js, and Rust global tools through Nix Home Manager.

## Features

- **Python**: Manage global tools in `other-dependencies/python.nix`
- **Node.js**: Manage global tools in `other-dependencies/nodejs.nix`
- **Rust**: Manage global tools in `other-dependencies/rust.nix`

## Structure

- `python.nix` - Python global tools
- `nodejs.nix` - Node.js global tools
- `rust.nix` - Rust global tools
- `default.nix` - Main module that imports the others

## Usage

### Installation

The system is already imported into your Home Manager configuration. To apply any changes, simply run:

```bash
darwin-rebuild switch
```

### Adding Packages

To add a global tool, edit the corresponding `.nix` file:

#### Python Global Tools

Edit `other-dependencies/python.nix` and add the package name to the `dependencies` list in the `pyproject.toml` section:

```nix
# other-dependencies/python.nix
...
dependencies = [
    "black>=23.0.0",
    "speckit" # Add your new tool here
]
...
```

#### Node.js Global Tools

Edit `other-dependencies/nodejs.nix` and add the package name to the `devDependencies` section of the `package.json`:

```nix
# other-dependencies/nodejs.nix
...
"devDependencies": {
    "typescript": "^5.0.0",
    "prettier": "^3.0.0" # Add your new tool here
}
...
```

#### Rust Global Tools

Edit `other-dependencies/rust.nix` and add the package to the `dependencies` section of the `Cargo.toml`:

```nix
# other-dependencies/rust.nix
...
[dependencies]
cargo-edit = "0.12"
# Add your new tool here
...
```

After editing any of the `.nix` files, run `darwin-rebuild switch` to apply the changes. Then, run the `install-global-deps` command to install the tools.

That's it! Simple, declarative dependency management with native tooling configuration managed by Nix.