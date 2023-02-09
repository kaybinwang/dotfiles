# shellcheck shell=sh
local arch=$(uname -p)
if [ "$arch" = 'arm' ]; then
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    __print_warning "Couldn't find an ARM installation of Homebrew."
  fi
fi
