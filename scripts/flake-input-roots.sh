#!/usr/bin/env bash
# Pin this flake's inputs so garbage collection cannot delete them.
#
# Why: flake input sources (GitHub tarballs) are NOT GC roots. After
# `nix-collect-garbage --delete-older-than 30d` they are deleted, and the next
# nix command silently re-downloads them from github.com — slow, and prone to
# stalling (nix has no read timeout; see `stalled-download-timeout`).
#
# This materialises every input — transitively, including inputs-of-inputs such
# as llm-agents' own pinned nixpkgs — and pins each one with an indirect GC
# root. Verified behaviour: the roots show up in `nix-store -q --roots` and the
# paths disappear from `nix-collect-garbage --dry-run`.
#
# Idempotent: the root directory is rebuilt on every run, so inputs removed by
# a later `nix flake update` stop being protected (and can then be collected).
#
# Run via ./scripts/setup.sh, or by hand after `nix flake update`.
#
# Implementation notes (both cost me a debugging round — don't "simplify"):
#   * No `mapfile`: macOS ships bash 3.2, where it does not exist.
#   * One `--add-root` per path, into a dedicated directory. Passing several
#     paths to a single --add-root emits numbered links (flake-inputs,
#     flake-inputs-2, …) which a later `rm -f <link>` would not clean up.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
FLAKE_DIR="$(dirname "$SCRIPT_DIR")"
cd "$FLAKE_DIR"

export PATH="/nix/var/nix/profiles/default/bin:$PATH"

ROOT_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nix/gcroots/flake-inputs"
PATHS_FILE="$(mktemp "${TMPDIR:-/tmp}/flake-inputs.XXXXXX")"
trap 'rm -f "$PATHS_FILE"' EXIT

# 1. Materialise and enumerate every input source, transitively.
#    `nix flake archive` copies missing inputs into the store and prints the
#    nested tree as JSON; walk it and collect the /nix/store paths. Starting at
#    the inputs (not the top-level node) skips this repo's own source.
nix flake archive --json | python3 -c '
import json, sys

seen = set()

def walk(node):
    if not isinstance(node, dict):
        return
    path = node.get("path")
    if isinstance(path, str) and path.startswith("/nix/store/") and path not in seen:
        seen.add(path)
        print(path)
    for child in (node.get("inputs") or {}).values():
        walk(child)

for child in (json.load(sys.stdin).get("inputs") or {}).values():
    walk(child)
' > "$PATHS_FILE"

if [ ! -s "$PATHS_FILE" ]; then
  echo "flake-input-roots: no inputs found — nothing to pin" >&2
  exit 1
fi

# 2. Rebuild the root set. Only after the archive above succeeded, so a failed
#    fetch leaves the previous roots intact rather than dropping protection.
rm -rf "$ROOT_DIR"
mkdir -p "$ROOT_DIR"

count=0
while IFS= read -r path; do
  [ -n "$path" ] || continue
  nix-store --add-root "$ROOT_DIR/$(basename "$path")" --indirect -r "$path" >/dev/null
  count=$((count + 1))
done < "$PATHS_FILE"

echo "Pinned $count flake input source(s) under $ROOT_DIR"
