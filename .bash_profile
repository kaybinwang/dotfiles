export CLICOLOR=1

# light colors
export LSCOLORS=ExFxBxDxCxegedabagacad

# flush history on each command
export PROMPT_COMMAND="history -a"

# bash completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion

  # Add git completion to aliases
  __git_complete gm _git_merge

  __git_complete g __git_main
  __git_complete gs _git_status
  __git_complete gd _git_diff
  __git_complete gf _git_fetch
  __git_complete grb _git_rebase
  __git_complete grbi _git_rebase
  __git_complete gl _git_log
  #__git_complete glp _git_log
  __git_complete ga _git_add
  __git_complete gb _git_branch
  __git_complete gbd _git_branch
  __git_complete gbD _git_branch
  __git_complete gco _git_checkout
  __git_complete gcob _git_checkout
  __git_complete gc _git_commit
  __git_complete gcm _git_commit
  __git_complete gp _git_pull
  __git_complete gpush _git_push
fi

# Vim commands in bash
set -o vi
bind '"jj":"\e"'


source ~/.bash_prompt
source ~/.bash_aliases
source ~/.bash_extras

export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
