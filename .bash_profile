pushd "$HOME" &> /dev/null

export CLICOLOR=1

# light colors
export LSCOLORS=ExFxBxDxCxegedabagacad
# dark colors
#export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# right before prompting for the next command, save the previous command in a
# file.
function onPrompt() {
  echo "$(date +%Y-%m-%d--%H-%M-%S) $(hostname) $PWD $(history 1)" \
    >> ~/.full_history
}
PROMPT_COMMAND=onPrompt

# Set all editors to neovim (e.g. Git commit editor)
if command -v nvim &>/dev/null; then
  export VISUAL=nvim
  export EDITOR="$VISUAL"
fi

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='
  --color fg:188,hl:110,fg+:222,bg+:234,hl+:111
  --color info:183,prompt:110,spinner:107,pointer:167,marker:215
'

parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
#export PS1="\[\e[32m\]\W\[\e[m\] \[\e[31m\]>\[\e[m\] "

# bash completion
if [ -f "$(brew --prefix)"/etc/bash_completion ]; then
  source "$(brew --prefix)"/etc/bash_completion

  # Add git completion to aliases
  __git_complete gm _git_merge

  __git_complete g __git_main
  __git_complete gs _git_status
  __git_complete gd _git_diff
  __git_complete gf _git_fetch
  __git_complete grb _git_rebase
  __git_complete grbi _git_rebase
  __git_complete gl _git_log
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

# Load all ssh keys in keychain for MacOS.
ssh-add -A &>/dev/null

# Vim commands in bash
set -o vi
bind '"jj":"\e"'

export PROJECT_PERSONAL="$HOME/projects/personal"
export PROJECT_WORK="$HOME/projects/work"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export GOPATH="$PERSONAL_PROJECT/go"
export PATH=$GOPATH/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source .bash_aliases
source .bash_extras

popd &> /dev/null
