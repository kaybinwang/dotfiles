#!/usr/bin/env sh

set -euo

. scripts/utils/log.sh

# TODO: fix how this doesn't work if the CWD isn't ~/projects/dotfiles
export PROJECTS_DIR="$HOME/projects"
export DOTFILES_DIR="$PROJECTS_DIR/dotfiles"
export NAV_DIR="$PROJECTS_DIR/nav"

log_info "Bootstrapping developer environment..."
mkdir -p "$PROJECTS_DIR"
touch "$DOTFILES_DIR/.config/sh/work.sh"  # create to avoid warning on first load

log_info "Installing packages..."
./scripts/packages/install.sh

log_info "Installing dotfiles..."
./scripts/symlink-dotfiles.sh
