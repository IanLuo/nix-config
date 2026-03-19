#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
TOOLS_CONFIG_FILE="$REPO_DIR/other-dependencies/tools-config.nix"

if [ ! -f "$TOOLS_CONFIG_FILE" ]; then
  echo "Missing tools config: $TOOLS_CONFIG_FILE" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

echo "Checking for new versions of other dependencies..."

CONFIG_JSON="$(nix eval --json --file "$TOOLS_CONFIG_FILE")"

check_git_dependency() {
  local name="$1"
  local url="$2"
  local current_rev="$3"
  local latest_rev

  echo "  Checking Git dependency: $name from $url"
  latest_rev="$(git ls-remote "$url" HEAD | cut -f1)"

  if [ "$latest_rev" != "$current_rev" ]; then
    echo "    New version available for $name"
    echo "      Current rev: $current_rev"
    echo "      Latest rev:  $latest_rev"
  else
    echo "    $name is up to date"
  fi
}

check_npm_dependency() {
  local name="$1"
  local package="$2"
  local current_version="$3"
  local latest_version

  echo "  Checking npm dependency: $name ($package)"
  latest_version="$(nix shell nixpkgs#nodejs --command npm view "$package" version)"

  if [ "$latest_version" != "$current_version" ]; then
    echo "    New version available for $name"
    echo "      Current version: $current_version"
    echo "      Latest version:  $latest_version"
  else
    echo "    $name is up to date"
  fi
}

echo "Processing Python dependencies..."
while IFS= read -r dep; do
  name="$(jq -r '.key' <<<"$dep")"
  source_type="$(jq -r '.value.source' <<<"$dep")"

  if [ "$source_type" = "git" ]; then
    url="$(jq -r '.value.url' <<<"$dep")"
    rev="$(jq -r '.value.rev' <<<"$dep")"
    check_git_dependency "$name" "$url" "$rev"
  else
    echo "  Unsupported source type for Python dependency $name: $source_type"
  fi
done < <(jq -c '.python | to_entries[]?' <<<"$CONFIG_JSON")

echo "Processing Node.js dependencies..."
while IFS= read -r dep; do
  name="$(jq -r '.key' <<<"$dep")"
  package="$(jq -r '.value.package' <<<"$dep")"
  version="$(jq -r '.value.version' <<<"$dep")"
  check_npm_dependency "$name" "$package" "$version"
done < <(jq -c '.nodejs | to_entries[]?' <<<"$CONFIG_JSON")

echo "Dependency check complete."
