#!/usr/bin/env bash

set -e

url="https://github.com/nixos/nixpkgs-channels"
channel="${@:-nixpkgs-unstable}"
rev="$(git ls-remote "$url" "$channel" | cut -f1)"
archive="$url/archive/$rev.tar.gz"
sha=$(nix-prefetch-url --unpack "$archive")
cat <<EOF
fetchTarball {
  url = $archive;
  sha256 = "$sha";
}
EOF
