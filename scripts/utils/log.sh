# shellcheck shell=bash

declare -r RED="\033[01;31m"
declare -r GREEN="\033[01;32m"
declare -r YELLOW="\033[01;33m"
declare -r BLUE="\033[01;34m"
declare -r BOLD="\033[1m"
declare -r RESET="\033[00m"

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
  local -r color="$1"
  local -r log_level="$2"
  local -r curr_time="$(__get_current_datetime)"

  shift
  shift

  echo -e "${BOLD}${color}[$curr_time] [$log_level] $* $RESET"
}

__get_current_datetime() {
  date +"%Y-%m-%dT%H:%M:%S%z"
}
