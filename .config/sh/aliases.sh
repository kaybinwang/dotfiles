# shellcheck shell=sh
alias sudo='sudo '

## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias -- -='cd -'

## Show hidden files ##
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -FGlAhprt'                     # ls with info
alias mkdir='mkdir -pv'                     # mkdir with parents
alias less='less -FSRXc'                    # Preferred 'less' implementation

if [ "$TERM" = 'xterm-kitty' ]; then
  alias ssh='kitty +kitten ssh'
fi

alias ebc="$EDITOR $HOME/.bashrc"
alias sbc="source $HOME/.bashrc"
alias esa="$EDITOR $HOME/.config/sh/aliases.sh"
alias ese="$EDITOR $HOME/.config/sh/env.sh"
alias esp="$EDITOR $HOME/.config/sh/profile.sh"
alias esw="$EDITOR $HOME/.config/sh/work.sh"
alias szc="source $HOME/.zshrc"
alias ezc="$EDITOR $HOME/.zshrc"

alias ekc="$EDITOR $HOME/.config/kitty/kitty.conf"

alias egc="$EDITOR $HOME/.gitconfig"
alias esc="$EDITOR $HOME/.ssh/config"

alias c='clear'

# tmux with 256 colors
alias tmux='tmux -2'

tmux-new() {
  tmux -2 new-session -s main -n system \; \
      split-window -dv htop \; \
    new-window -n dotfiles -c "$DOTFILE_PATH" '$EDITOR ~/.config/nvim/init.vim' \; \
      split-window -dv -c "$DOTFILE_PATH" -p 10 \; \
    new-window -n dev -c "$PROJECT_PERSONAL" \; \
    attach -t main \;
}

# default to neovim if it exists
if command -v nvim &>/dev/null; then
  alias vi='nvim'
  alias vim='nvim'
elif command -v vim &>/dev/null; then
  alias vi='vim'
fi

# run brew using Intel
alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias zgrep='zgrep --color=auto'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gau='git add -u'
alias gb='git branch'
gbd() {
  if [[ "$1" = "-" ]]; then
    git branch -d '@{-1}'
  else
    git branch -d "$@"
  fi
}
gbD() {
  if [[ "$1" = "-" ]]; then
    git branch -D '@{-1}'
  else
    git branch -D "$@"
  fi
}
alias gcl='git clone'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcane='git commit --amend --no-edit'
alias gco="git checkout"
alias gcob='git checkout -b'
alias gf='git fetch'
alias gd='git diff'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gr='git reset'
alias gl='git log'
alias gls='git ls'
alias gm='git merge'
alias gpoh='git push origin HEAD'
alias gpfoh='git push -f origin HEAD'
alias gsh='git show'
alias gst='git stash'
alias gstp='git stash pop'
alias gsta='git stash apply'
alias gg='git grep'
if command -v __git_complete &>/dev/null; then
  # Add git completion to aliases
  __git_complete gm _git_merge

  __git_complete g __git_main
  __git_complete gs _git_status __git_complete gd _git_diff
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
else
  __print_warning "__git_complete not found. Did you install bash-completion?"
fi
greplace() {
  local -r temp_ext=original
  local -r src="$1"
  local -r dst="$2"
  if [[ -z "$src" ]]; then
    echo "Need to provide an input." >&2
    return 1
  fi
  if [[ -z "$dst" ]]; then
    echo "Need to provide a replacement for the input." >&2
    return 1
  fi
  local -r modified_files=$(git grep -l "$src" | tee >(xargs sed -i .$temp_ext "s/$src/$dst/g"))
  for file in $modified_files; do
    rm $file.$temp_ext
  done
}
