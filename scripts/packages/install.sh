#!/usr/bin/env sh

set -euo

. scripts/utils/log.sh
. scripts/utils/system.sh

REPOS="
"

SHARED_PACKAGES="
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
"

BREW_PACKAGES="
bash-language-server
kotlin-language-server
pyright
pre-commit
"

BREW_CASKS="
kitty
"

APK_PACKAGES="
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
"

install_packages_for_mac_os() {
  if ! command -v brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew already exists. Skipping..."
  fi

  # TODO: automate installing Intel brew (only when using ARM)?

  echo "Tapping third-party repositories..."
  echo "$REPOS" | xargs brew tap

  echo "Installing packages..."
  echo "$SHARED_PACKAGES" | xargs brew install
  echo "$BREW_PACKAGES" | xargs brew install

  echo "Installing casks..."
  echo "$BREW_CASKS" | xargs brew install --cask
}

install_packages_for_alpine() {
  sudo apk upgrade --no-cache
  echo "$SHARED_PACKAGES $APK_PACKAGES" | xargs sudo apk add --update --no-cache
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
  # TODO: investigate why sudo is required for GHA
  sudo git clone https://github.com/kaybinwang/nav "$NAV_DIR"
}

install_packages
install_nav
