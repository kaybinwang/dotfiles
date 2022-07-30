export PROJECT_PERSONAL="$HOME/projects/personal"
export PROJECT_WORK="$HOME/projects/work"

# TODO: verify if branching is needed
if command -v nvim &>/dev/null; then
  export VISUAL=nvim
elif command -v vim &>/dev/null; then
  export VISUAL=vim
fi
export EDITOR="$VISUAL"
