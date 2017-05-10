export CLICOLOR=1

# light colors
export LSCOLORS=ExFxBxDxCxegedabagacad

# flush history on each command
export PROMPT_COMMAND="history -a"

# bash completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# Vim commands in bash
set -o vi
bind '"jj":"\e"'

. ~/.bash_prompt
. ~/.bash_aliases
