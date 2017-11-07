export IDEAVIMRC="$HOME/.ideavimrc"

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
alias ls='ls -G'
alias la='ls -a'
alias ll='ls -FGlAhprt'                       # ls with info
alias mkdir='mkdir -pv'                      # mkdir with parents
alias less='less -FSRXc'                    # Preferred 'less' implementation

alias ebp="vi $HOME/.bash_profile"
alias eba="vi $HOME/.bash_aliases"
alias ebe="vi $HOME/.bash_extras"
alias sbp="source $HOME/.bash_profile"

alias c='clear'

# Binary aliases
alias tmux='tmux -2'                        # tmux with 256 colors
alias vi='nvim'                             # neovim
alias vim='nvim'                            # neovim

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gau='git add -u'
alias gb='git branch'
#alias gbd='git branch -d'
#alias gbD='git branch -D'
function gbd() {
  if [[ "$1" = "-" ]]; then
    git branch -d '@{-1}'
  else
    git branch -d "$@"
  fi
}
function gbD() {
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
function gco() {
  git checkout "$@"
}
alias gcor='git checkout'
alias gcob='git checkout -b'
alias gf='git fetch'
alias gd='git diff'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gr='git reset'
alias grh='git reset HEAD'
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

alias pp="cd $PROJECT_PERSONAL"
alias wp="cd $PROJECT_WORK"

pdf () {
  pdflatex "$1".tex && rm "$1".out "$1".log "$1".aux && open "$1".pdf;
}

chrome () {
  open -a "Google Chrome" "$1"
}
