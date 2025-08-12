#!/usr/bin/env bash

set -euo pipefail

# Function to display help
usage() {
  echo "Usage: $0 {status|gc|optimise|disk-usage|help}"
  echo
  echo "Commands:"
  echo "  status       - Show the status of the Nix store."
  echo "  gc           - Run garbage collection to remove old generations."
  echo "  optimise     - Optimise the Nix store."
  echo "  disk-usage   - Show disk usage of the Nix store."
  echo "  help         - Display this help message."
}

# Main command logic
case "${1-}" in
  status)
    echo "Nix Store Status"
    echo "================="
    echo "Paths in the store: $(ls -1 /nix/store | wc -l)"
    echo "Total size: $(du -sh /nix/store | cut -f1)"
    ;;
  gc)
    echo "Running Nix garbage collection..."
    nix-collect-garbage -d
    echo "Garbage collection complete."
    ;;
  optimise)
    echo "Optimising the Nix store..."
    nix-store --optimise
    echo "Store optimisation complete."
    ;;
  disk-usage)
    echo "Disk Usage of the Nix Store"
    echo "============================"
    echo "For a more detailed analysis, consider using 'nix-du'."
    echo
    echo "Total size of the Nix store:"
    du -sh /nix/store
    echo
    echo "Top 10 biggest paths in the store:"
    du -sh /nix/store/* | sort -rh | head -n 10
    ;;
  help)
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac