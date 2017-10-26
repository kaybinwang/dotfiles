###############################################################################
#
# print.sh
#
# Utility functions for printing colorful debug, info, warning, and error
# messages to stdio.
#
# Source:
#   https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
#
###############################################################################

FG_RED="$(tput setaf 1)"
FG_GREEN="$(tput setaf 2)"
FG_YELLOW="$(tput setaf 3)"
FG_BLUE="$(tput setaf 4)"
FG_MAGENTA="$(tput setaf 5)"
FG_CYAN="$(tput setaf 6)"
FG_WHITE="$(tput setaf 7)"

BOLD="$(tput bold)"
UNDERLINE="$(tput smul)"

RESET="$(tput sgr0)"

function print_debug() {
  if [ "$DEBUG" ]; then
    echo "${FG_CYAN}[DEBUG]: $1${RESET}"
  fi
}

function print_info() {
  echo "${FG_BLUE}[INFO]:${RESET} $1${RESET}"
}

function print_verbose() {
  echo "$1"
}

function print_warning() {
  echo "${FG_YELLOW}[WARNING]:${RESET} $1${RESET}"
}

function print_error() {
  echo "${FG_RED}[ERROR]: $1${RESET}"
}

function bold() {
  echo "${BOLD}$1${RESET}"
}

function underline() {
  echo "${UNDERLINE}$1${RESET}"
}
