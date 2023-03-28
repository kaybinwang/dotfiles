#!/usr/bin/env bash

set -eo pipefail

abs_path() {
  echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

DOTFILES_PATH="$(abs_path ".")"

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
