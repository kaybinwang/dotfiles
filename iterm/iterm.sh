#!/bin/bash

function install_iterm() {
  command -v iterm2 && return 0
  brew cask install iterm2

}

function config_iterm() {
  local -r iterm_dir="$DOTFILE_PATH/iterm/prefs"

  # Specify the preferences directory
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder \
    -string "$DOTFILE_PATH/iterm/"

  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder \
    -bool true
}

function main() {
  install_iterm && config_iterm
}

main "$@"
