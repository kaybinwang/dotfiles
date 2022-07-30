__source_if_exists() {
  if [ -s "$1" ]; then
    source "$1"
  else
    __print_warning "Unable to source '$1'."
  fi
}

__print_warning() {
  echo '[WARN]' $@
}
