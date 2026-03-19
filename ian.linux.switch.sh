#!/usr/bin/env bash

set -euo pipefail

HOME_CONFIG_NAME="${HOME_CONFIG_NAME:-ian-linux-dev}" exec "$(dirname "$0")/scripts/setup.sh" "$@"
