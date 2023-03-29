# shellcheck shell=sh

load_brew() {
  local arch=$(uname -p)
  if [ "$arch" = 'arm' ] && [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    return 0
  fi
  if [ "$arch" = 'i386' ] && [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
    return 0
  fi
  __print_warning "Couldn't find installation of Homebrew for $arch."
}

load_brew
