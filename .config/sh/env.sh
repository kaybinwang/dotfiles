# shellcheck shell=sh
source .config/sh/helpers.sh

export PERSONAL_PROJECTS="$HOME/projects/personal"
export WORK_PROJECTS="$HOME/projects/work"

nvim="$(__get_nvim_path_with_fallback)"
if [ -z "$nvim" ]; then
  export VISUAL=$nvim
  export EDITOR="$VISUAL"
fi
