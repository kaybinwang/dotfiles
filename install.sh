#!/usr/bin/env bash

set -euo pipefail

source scripts/utils/log.sh

log_info "Installing packages..."
./scripts/packages/install.sh

log_info "Installing dotfiles..."
./scripts/symlink-dotfiles.sh
