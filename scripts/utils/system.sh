# shellcheck shell=sh

is_mac_os() {
  test "$(uname)" = Darwin
}

is_linux_os() {
  test "$(uname)" = Linux
}
