#!/bin/bash

#
# brew.sh
#

set -e

function brew_install() {
  local -r pkg="$1"
  if ! brew ls --versions "$pkg" >/dev/null; then
    brew install "$pkg"
  fi
}

function brew_cask_install() {
  local -r pkg="$1"
  if ! brew cask ls --versions "$pkg" >/dev/null; then
    brew cask install "$pkg"
  fi
}
