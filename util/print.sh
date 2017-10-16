#!/bin/bash

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

declare -r FG_RED="$(tput setaf 1)"
declare -r FG_GREEN="$(tput setaf 2)"
declare -r FG_YELLOW="$(tput setaf 3)"
declare -r FG_BLUE="$(tput setaf 4)"
declare -r FG_MAGENTA="$(tput setaf 5)"
declare -r FG_CYAN="$(tput setaf 6)"
declare -r FG_WHITE="$(tput setaf 7)"

declare -r BOLD="$(tput bold)"
declare -r UNDERLINE="$(tput smul)"

declare -r RESET="$(tput sgr0)"

function print_debug() {
  if [ "$DEBUG" ]; then
    echo "${FG_CYAN}[DEBUG]: $1${RESET}"
  fi
}

function print_info() {
  echo "${FG_BLUE}[INFO]:${RESET} $1${RESET}"
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
