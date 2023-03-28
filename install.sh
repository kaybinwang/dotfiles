#!/usr/bin/env bash

set -euo pipefail

REPOS=(
  homebrew/cask-fonts
)

PACKAGES=(
  # TODO: make `nav` a brew formula and update shell profile to source brew path
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

# TODO: move this out
if [ "$(uname)" == "Darwin" ]; then
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
fi

echo "Installing dotfiles..."
./scripts/symlink-dotfiles.sh
