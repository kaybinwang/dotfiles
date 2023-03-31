# shellcheck shell=bash

__print_warning() {
  echo '[WARN]' "$@" 1>&2
}

__source_if_exists() {
  if [ -f "$1" ]; then
    # shellcheck disable=SC1090
    source "$1"
  else
    __print_warning "Unable to source '$1'."
  fi
}

__get_nvim_path_with_fallback() {
  if path=$(command -v nvim) \
    || path=$(command -v vim) \
    || path=$(command -v vi)
  then
    echo "$path"
    return 0
  fi
  __print_warning "Couldn't find any vim installation!"
  return 1
}
