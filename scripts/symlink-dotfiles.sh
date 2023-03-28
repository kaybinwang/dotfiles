#!/usr/bin/env bash

set -euo pipefail

DOTFILES_PATH="$(pwd)"

DOTFILES=(
  .bash_profile
  .bashrc
  .config/bat
  .config/kitty
  .config/nvim
  .config/sh
  .gitconfig
  .gitconfig-personal
  .gitconfig-work
  .zshrc
)

echo "Installing dotfiles..."
for dotfile in "${DOTFILES[@]}"; do
  src="$DOTFILES_PATH/$dotfile"
  dst="$HOME/$dotfile"

  # first check if parent directory needs to be created
  dst_dir=$(dirname "$dst")
  if [ ! -e "$dst_dir" ]; then
    mkdir -p "$dst_dir"
  fi
  if [ -L "$dst" ]; then
    # safe to delete symlink
    rm "$dst"
  fi
  if [ -e "$dst" ]; then
    # we shouldn't automatically delete a pre-existing file/directory, so the
    # user needs to manually verify it's safe to remove before trying again
    echo "ERROR: $dst already exists. Please remove before trying again."
    continue
  fi
  echo "Creating symlink from $dst -> $src..."
  ln -s "$src" "$dst"
done
