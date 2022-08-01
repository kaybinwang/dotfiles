# shellcheck shell=sh
export PROJECT_PERSONAL="$HOME/projects/personal"
export PROJECT_WORK="$HOME/projects/work"

if command -v nvim &>/dev/null; then
  export VISUAL=nvim
elif command -v vim &>/dev/null; then
  export VISUAL=vim
elif command -v vi &>/dev/null; then
  export VISUAL=vi
fi
export EDITOR="$VISUAL"
