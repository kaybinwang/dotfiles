# shellcheck shell=sh

is_mac_os() {
  test "$(uname)" = Darwin
}

is_linux_os() {
  test "$(uname)" = Linux
}

is_alpine_os() {
  test -f /etc/os-release && grep -q '^ID=alpine' /etc/os-release
}

is_debian_os() {
  test -f /etc/os-release && grep -q '^ID=debian' /etc/os-release
}
