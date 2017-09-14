## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

 
## Show hidden files ##
alias ls='ls -G'
alias la='ls -a'
alias ll='ls -FGlAhprt'                       # ls with info
alias mkdir='mkdir -pv'                      # mkdir with parents
alias less='less -FSRXc'                    # Preferred 'less' implementation

alias c='clear'

# Binary aliases
alias tmux='tmux -2'                        # tmux with 256 colors
alias vim='vi'                              # homebrew's vim

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gau='git add -u'
alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gcl='git clone'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcane='git commit --amend --no-edit'
alias gco='git checkout'
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
alias gg='git grep'

ECLIPSE_HOME='/Applications/Eclipse.app/Contents/Eclipse'
alias eclimd="$ECLIPSE_HOME/eclimd"

EVERNOTE_DIR="$HOME/projects/evernote"

alias buildweb="$EVERNOTE_DIR/web/web/src/main/scripts/build.sh"

pdf () {
  pdflatex "$1".tex && rm "$1".out "$1".log "$1".aux && open "$1".pdf;
}

chrome () {
  open -a "Google Chrome" "$1"
}
