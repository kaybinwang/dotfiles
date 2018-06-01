#===============================================================================
# TODO
#===============================================================================
# make sure .zsh is a real directory
# number the table of contents

#===============================================================================
# Table of contents
#===============================================================================
# 1. Plugins
# 2. Vim Bindings
# 3. Keybindings
# 4. Interface

#===============================================================================
# 1. Plugins
#===============================================================================

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# Make sure to use double quotes
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"

# Set the priority when loading
# e.g., zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
# (If the defer tag is given 2 or above, run after compinit command)
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

#===============================================================================
# 2. Vim Bindings
#===============================================================================

export VISUAL=nvim
export EDITOR="$VISUAL"

# Vim mode
bindkey -v
bindkey "jj" vi-cmd-mode

# Use real backspace instead of vi-backward-delete-char
# https://unix.stackexchange.com/a/206933
bindkey -v '^?' backward-delete-char
bindkey -v '^h' backward-delete-char

# Scroll through partial matches when in insert mode
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down

# Complete autosuggestion when in insert mode
bindkey '^ ' autosuggest-accept

# Enable parens, quotes and surround text-objects
# ciw ci" text objects
# Source: https://www.reddit.com/r/vim/comments/4995nr/navigate_your_command_line_with_modal_vi/d0qmcbl/
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $m $c select-bracketed
    done
done

autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

autoload -Uz surround
zle -N delete-surround surround
zle -N change-surround surround
zle -N add-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

#===============================================================================
# 3. Interface
#===============================================================================

#-------------------------------------------------------------------------------
# 3.1 Colors
#-------------------------------------------------------------------------------

export CLICOLOR
export LSCOLORS=ExFxBxDxCxegedabagacad

#-------------------------------------------------------------------------------
# 3.2 Syntax Hightlighting
#-------------------------------------------------------------------------------

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# path zsh syntax highlighting
#ZSH_HIGHLIGHT_STYLES[default]='fg=blue'
#ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow'
#ZSH_HIGHLIGHT_STYLES[path]='fg=blue,bold,dim'

# Syntax highlighting for previous command suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# To differentiate aliases from other command types
#ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'

# To have paths colored instead of underlined
#ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# To disable highlighting of globbing expressions
#ZSH_HIGHLIGHT_STYLES[globbing]='none'


#-------------------------------------------------------------------------------
# 3.3 Prompt
#-------------------------------------------------------------------------------

setopt prompt_subst

unset PROMPT

# Git context
function parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

# GCP context
function gcp_prompt_info() {
  local cfg="$(cat ~/.config/gcloud/active_config 2>/dev/null)"
  if [ -n "$cfg" ]; then
    case "$cfg" in
      *development*)
        cfg='dev'
        ;;
      *testing*)
        cfg='test'
        ;;
      *production*)
        cfg='prod'
        ;;
      *)
        ;;
    esac
    echo -n "(gcp:$cfg) "
  fi
}

# Kubernetes context
function kube_prompt_info() {
  local cfg="$(kubectl config current-context 2>/dev/null)"
  if [ -n "$cfg" ]; then
    case "$cfg" in
      *development*)
        cfg='dev'
        ;;
      *testing*)
        cfg='test'
        ;;
      *production*)
        cfg='prod'
        ;;
      *)
        ;;
    esac
    echo -n "(kub:$cfg) "
  fi
}


PROMPT="${PROMPT}%(?.%F{green}[✔]%f.%F{red}[✘]%f) "

# Show current working directory, favoring ~ for home
PROMPT="${PROMPT}%F{blue}%~%f "

# Show working git branch if applicable
# We can't encode a trailing space or else it will always be present.
# Trailing space should be appended in parse_git_branch.
if command -v git &>/dev/null; then
  PROMPT="${PROMPT}%F{yellow}\$(parse_git_branch)%f"
fi

# Show Google Cloud Project if applicable
if command -v gcloud &>/dev/null; then
  PROMPT="${PROMPT}%F{red}\$(gcp_prompt_info)%f"
fi

# Show Kubernetes cluster if applicable
if command -v kubectl &>/dev/null; then
  PROMPT="${PROMPT}%F{magenta}\$(kube_prompt_info)%f"
fi

export PROMPT="${PROMPT}%# "

# Update right side prompt that shows vim mode.
function zle-line-init zle-keymap-select {
  local NORMAL="%{$fg_bold[blue]%} [% NORMAL]% %{$reset_color%}"
  local INSERT="%{$fg_bold[green]%} [% INSERT]% %{$reset_color%}"
  RPS1="${${KEYMAP/vicmd/$NORMAL}/(main|viins)/$INSERT} $EPS1"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

#===============================================================================
# 4. Environment
#===============================================================================

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

export PROJECT_PERSONAL="$HOME/projects/personal"
export PROJECT_WORK="$HOME/projects/work"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export GOPATH="$PROJECT_PERSONAL/go"
export PATH=$GOPATH/bin:$PATH

if [ -f "$HOME/.bash_aliases" ]; then
  source "$HOME/.bash_aliases"
fi

if [ -f "$HOME/.env" ]; then
  source "$HOME/.env"
fi

# Load all ssh keys in keychain for MacOS.
ssh-add -A &>/dev/null

# allow for unquoted wildcards, e.g. `ls *.sh`.
unsetopt no_match

# History
#set history size
export HISTSIZE=10000
#save history after logout
export SAVEHIST=10000
#history file
export HISTFILE=~/.zhistory
#append into history file
setopt INC_APPEND_HISTORY
#save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
#add timestamp for each entry
setopt EXTENDED_HISTORY

#===============================================================================
# 5. Completion
#===============================================================================

# menu if nb items > 2
zstyle ':completion:*' menu select=2

#-------------------------------------------------------------------------------
# 5.1 Git Completion
#-------------------------------------------------------------------------------

compdef g=git

_git 2>/dev/null
compdef '__gitcomp_nl "$(__git_heads '' $track)"' gco
compdef '__gitcomp_nl "$(__git_heads '' $track)"' gbd
compdef '__gitcomp_nl "$(__git_heads '' $track)"' gbD

#test -z "$TMUX" && (tmux attach || tmux new-session)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
