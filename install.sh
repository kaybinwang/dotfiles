#!/usr/bin/env bash

set -eo pipefail

abs_path() {
  echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

DOTFILES_PATH="$(dirname "$(abs_path "${BASH_SOURCE[0]}")")"

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

REPOS=(
  homebrew/cask-fonts
)

PACKAGES=(
  bash
  bash-completion
  bash-language-server
  bat
  coreutils
  fzf
  git
  jq
  kotlin-language-server
  lua-language-server
  neovim
  ripgrep
  shellcheck
  zsh
)

CASKS=(
  font-fira-code-nerd-font
)

if ! command -v brew; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already exists. Skipping..."
fi

# TODO: automate installing Intel brew (only when using ARM)?

echo "Tapping third-party repositories..."
brew tap "${REPOS[@]}"

echo "Installing packages..."
brew install "${PACKAGES[@]}"

echo "Installing casks..."

brew install --cask "${CASKS[@]}"

echo "Installing dotfiles..."
for dotfile in "${DOTFILES[@]}"; do
  src="$DOTFILES_PATH/$dotfile"
  dst="$HOME/$dotfile"
  if [ -L "$dst" ]; then
    # safe to delete symlink
    rm "$dst"
  fi
  if [ -e "$dst" ]; then
    # not sure if it's safe to remove, so user needs to manually verify
    echo "ERROR: $dst already exists. Please remove before trying again."
    continue
  fi
  echo "Creating symlink from $dst -> $src..."
  ln -s "$src" "$dst"
done
