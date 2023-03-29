#!/usr/bin/env bash

set -euo pipefail

source scripts/utils/log.sh
source scripts/utils/system.sh

declare -r REPOS=(
  homebrew/cask-fonts
)

declare -r PACKAGES=(
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

declare -r CASKS=(
  font-fira-code-nerd-font
)

install_packages_for_mac_os() {
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
}

install_packages_for_linux() {
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
}

install_packages() {
  log_info "Determining which OS to install packages for..."
  if is_mac_os; then
    log_info "Using Mac OS!"
    install_packages_for_mac_os
  elif is_linux_os; then
    log_info "Using Linux!"
    install_packages_for_linux
  else
    log_error "Unknown OS"
    exit 1
  fi
}

install_packages
