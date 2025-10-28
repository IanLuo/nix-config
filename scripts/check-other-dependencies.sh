#!/usr/bin/env bash

set -euo pipefail

NIX_CONFIG_FILE="/Users/ianluo/.config/darwin/other-dependencies/tools-config.nix"
TEMP_NIX_JSON_FILE="/Users/ianluo/.config/darwin/tmp/tools-config-json.nix"
NIX_OUTPUT_JSON_FILE="/Users/ianluo/.config/darwin/tmp/nix_output.json"

echo "Checking for new versions of other dependencies..."

# Evaluate the temporary Nix file and save output to a temporary JSON file
nix eval --json --file "$TEMP_NIX_JSON_FILE" > "$NIX_OUTPUT_JSON_FILE"
sed -i '' -e 's/^"//' -e 's/"$//' -e 's/\\//g' "$NIX_OUTPUT_JSON_FILE"

# Function to check Git dependencies
check_git_dependency() {
    local name="$1"
    local url="$2"
    local current_rev="$3"

    echo "  Checking Git dependency: $name from $url"
    latest_rev=$(git ls-remote "$url" HEAD | awk '{print $1}')

    if [ "$latest_rev" != "$current_rev" ]; then
        echo "    New version available for $name!"
        echo "      Current rev: $current_rev"
        echo "      Latest rev:  $latest_rev"
    else
        echo "    $name is up to date."
    fi
}

# Function to check Node.js (npm) dependencies
check_npm_dependency() {
    local name="$1"
    local package="$2"
    local current_version="$3"

    echo "  Checking npm dependency: $name ($package)"
    latest_version=$(nix shell nixpkgs#nodejs --command npm view "$package" version)

    if [ "$latest_version" != "$current_version" ]; then
        echo "    New version available for $name!"
        echo "      Current version: $current_version"
        echo "      Latest version:  $latest_version"
    else
        echo "    $name is up to date."
    fi
}

# Process Python dependencies
echo "Processing Python dependencies..."
python_deps=$(jq -r -c '.python | to_entries[]' "$NIX_OUTPUT_JSON_FILE")
for dep in $python_deps; do
    name=$(echo "$dep" | jq -r '.key')
    source_type=$(echo "$dep" | jq -r '.value.source')

    if [ "$source_type" == "git" ]; then
        url=$(echo "$dep" | jq -r '.value.url')
        rev=$(echo "$dep" | jq -r '.value.rev')
        check_git_dependency "$name" "$url" "$rev"
    else
        echo "  Unsupported source type for Python dependency $name: $source_type"
    fi
done

# Process Node.js dependencies
echo "Processing Node.js dependencies..."
nodejs_deps=$(jq -r -c '.nodejs | to_entries[]' "$NIX_OUTPUT_JSON_FILE")
for dep in $nodejs_deps; do
    name=$(echo "$dep" | jq -r '.key')
    package=$(echo "$dep" | jq -r '.value.package')
    version=$(echo "$dep" | jq -r '.value.version')
    check_npm_dependency "$name" "$package" "$version"
done

echo "Dependency check complete."
