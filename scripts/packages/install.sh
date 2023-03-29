#!/usr/bin/env bash

set -euo pipefail

source scripts/utils/log.sh
source scripts/utils/system.sh

declare -r REPOS=(
  homebrew/cask-fonts
)

declare -r SHARED_PACKAGES=(
  bash
  bash-completion
  bat
  coreutils
  docker
  fzf
  git
  jq
  lua-language-server
  neovim
  ripgrep
  shellcheck
  tmux
  yq
  zsh
)

declare -r BREW_PACKAGES=(
  bash-language-server
  kotlin-language-server
)

declare -r BREW_CASKS=(
  font-fira-code-nerd-font
)

declare -r APK_PACKAGES=(
  autoconf
  automake
  build-base
  ca-certificates
  cmake
  ctags
  curl
  file
  gcc
  git-doc
  libressl
  libtool
  nasm
  ncurses
  openssh-client
  wget
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
  brew install "${SHARED_PACKAGES[@]}"
  brew install "${BREW_PACKAGES[@]}"

  echo "Installing BREW_CASKS..."

  brew install --cask "${BREW_CASKS[@]}"
}

install_packages_for_alpine() {
  sudo apk upgrade --no-cache
  sudo apk add --update --no-cache "${SHARED_PACKAGES[@]}"
  sudo apk add --update --no-cache "${APK_PACKAGES[@]}"
}

install_packages() {
  log_info "Determining which OS to install packages for..."
  if is_mac_os; then
    log_info "Using Mac OS!"
    install_packages_for_mac_os
  elif is_linux_os; then
    log_info "Using Linux!"
    install_packages_for_alpine
  else
    log_error "Unknown OS"
    exit 1
  fi
}

install_nav() {
  # TODO: make `nav` a package formula and update shell profile to source brew path
  # this way we don't need to hardcode the personal projects path
  log_info "Installing nav..."
  mkdir -p "$HOME/projects/personal/nav"
  git clone https://github.com/kaybinwang/nav "$HOME/projects/personal/nav"
}

install_packages
install_nav
