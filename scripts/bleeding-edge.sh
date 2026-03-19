#!/usr/bin/env bash

# Helper script for managing bleeding-edge packages

set -euo pipefail

BLEEDING_EDGE_FILE="programs/bleeding-edge/default.nix"
DARWIN_CONFIG_NAME="${DARWIN_CONFIG_NAME:-ianluo}"

show_help() {
    echo "🩸 Bleeding-Edge Package Manager"
    echo "================================="
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  list                     List currently enabled bleeding-edge packages"
    echo "  add-git <name> <repo>    Add a new package from git"
    echo "  add-nixpkgs <name> <pkg> Add package from nixpkgs master"
    echo "  hash <repo> [rev]        Get SHA256 hash for a git repo"
    echo "  update <name>            Update a bleeding-edge package"
    echo "  remove <name>            Remove a bleeding-edge package"
    echo "  test                     Test bleeding-edge packages build"
    echo ""
    echo "Examples:"
    echo "  $0 hash https://github.com/cli/cli v2.42.0"
    echo "  $0 add-git gh-latest cli/cli"
    echo "  $0 add-nixpkgs bun-latest bun"
    echo "  $0 list"
    echo ""
}

list_packages() {
    echo "📋 Current bleeding-edge packages:"
    echo "=================================="
    
    if grep -q "bleedingPackages = {" "$BLEEDING_EDGE_FILE"; then
        # Extract uncommented package definitions
        sed -n '/bleedingPackages = {/,/};/p' "$BLEEDING_EDGE_FILE" | \
        grep -E "^\s*[a-zA-Z].*=" | \
        sed 's/^[[:space:]]*/  ✅ /' | \
        sed 's/ =.*//'
        
        echo ""
        echo "💡 To see all available examples, check: $BLEEDING_EDGE_FILE"
    else
        echo "  No bleeding-edge packages file found"
    fi
}

get_hash() {
    local repo="$1"
    local rev="${2:-HEAD}"
    
    echo "🔍 Getting hash for $repo@$rev..."
    
    if command -v nix-prefetch-git >/dev/null 2>&1; then
        nix-prefetch-git "$repo" --rev "$rev" --quiet | jq -r '.sha256'
    else
        echo "❌ nix-prefetch-git not found. Install with: nix-env -iA nixpkgs.nix-prefetch-git"
        return 1
    fi
}

add_git_package() {
    local name="$1"
    local repo="$2"
    
    if [[ -z "$name" || -z "$repo" ]]; then
        echo "❌ Usage: $0 add-git <package-name> <owner/repo>"
        echo "   Example: $0 add-git gh-latest cli/cli"
        return 1
    fi
    
    echo "🔄 Adding git package: $name from $repo"
    
    # Get the latest hash
    local hash
    hash=$(get_hash "https://github.com/$repo" "HEAD")
    
    if [[ -z "$hash" ]]; then
        echo "❌ Failed to get hash"
        return 1
    fi
    
    echo ""
    echo "📝 Add this to your $BLEEDING_EDGE_FILE:"
    echo "----------------------------------------"
    cat <<EOF
$name = buildFromGit {
  owner = "$(echo "$repo" | cut -d'/' -f1)";
  repo = "$(echo "$repo" | cut -d'/' -f2)";
  rev = "main";  # or specific version
  sha256 = "$hash";
  
  pname = "$name";
  version = "bleeding";
  
  # Add build dependencies as needed:
  # nativeBuildInputs = with pkgs; [ go ]; # or rustc, nodejs, etc.
  
  # buildPhase = ''
  #   make build
  # '';
  # 
  # installPhase = ''
  #   make install PREFIX=\$out
  # '';
};
EOF
    echo ""
    echo "💡 Edit the build/install phases according to the project's build system"
}

add_nixpkgs_package() {
    local name="$1"
    local package="$2"
    
    if [[ -z "$name" || -z "$package" ]]; then
        echo "❌ Usage: $0 add-nixpkgs <package-name> <nixpkgs-package>"
        echo "   Example: $0 add-nixpkgs bun-latest bun"
        return 1
    fi
    
    echo "📝 Add this to your $BLEEDING_EDGE_FILE:"
    echo "----------------------------------------"
    cat <<EOF
$name = fetchNixpkgsPackage {
  commit = "master";  # or specific commit hash
  package = "$package";
};
EOF
}

test_build() {
    echo "🧪 Testing bleeding-edge packages build..."
    
    if nix build ".#darwinConfigurations.${DARWIN_CONFIG_NAME}.config.system.build.toplevel" --show-trace; then
        echo "✅ Build successful!"
    else
        echo "❌ Build failed. Check the error messages above."
        return 1
    fi
}

main() {
    case "${1:-}" in
        "list")
            list_packages
            ;;
        "add-git")
            add_git_package "$2" "$3"
            ;;
        "add-nixpkgs")
            add_nixpkgs_package "$2" "$3"
            ;;
        "hash")
            get_hash "$2" "$3"
            ;;
        "test")
            test_build
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        "")
            show_help
            ;;
        *)
            echo "❌ Unknown command: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
