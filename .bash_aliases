alias la='ls -a'
alias ll='ls -FGlAhp'                       # ls with info
alias mkdir='mkdir -p'                      # mkdir with parents
alias less='less -FSRXc'                    # Preferred 'less' implementation

# Binary aliases
alias tmux='tmux -2'                        # tmux with 256 colors
alias vim='vi'                              # homebrew's vim

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gcob='git checkout -b'

pdf () {
  pdflatex "$1".tex && rm "$1".out "$1".log "$1".aux && open "$1".pdf;
}

chrome () {
  open -a "Google Chrome" "$1"
}
