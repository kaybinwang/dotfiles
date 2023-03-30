# shellcheck shell=bash

if [ "$(uname)" = "Darwin" ]; then
  # setup Homebrew so that the packages are available in PATH
  arch=$(uname -p)
  if [ "$arch" = 'arm' ] && [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    return 0
  fi
  if [ "$arch" = 'i386' ] && [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
    return 0
  fi
  __print_warning "Couldn't find installation of Homebrew for $arch."
fi
