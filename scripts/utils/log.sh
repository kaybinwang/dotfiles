# shellcheck shell=sh

RED="\033[01;31m"
GREEN="\033[01;32m"
YELLOW="\033[01;33m"
BLUE="\033[01;34m"
BOLD="\033[1m"
RESET="\033[00m"

log_info() {
  __log_message_with_time "$BLUE" INFO "$*"
}

log_success() {
  __log_message_with_time "$GREEN" SUCCESS "$*"
}

log_warn() {
  __log_message_with_time "$YELLOW" WARN "$*"
}

log_error() {
  __log_message_with_time "$RED" ERROR "$*"
}

__log_message_with_time() {
  color="$1"
  log_level="$2"
  curr_time="$(__get_current_datetime)"

  shift
  shift

  printf "${BOLD}${color}[$curr_time] [$log_level] $* $RESET"
}

__get_current_datetime() {
  date +"%Y-%m-%dT%H:%M:%S%z"
}
