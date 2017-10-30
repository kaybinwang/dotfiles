# TODO: make .zsh if it works

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

zplug load #--verbose

# For faster vim mode display changes
#export KEYTIMEOUT=1

export VISUAL=nvim
export EDITOR="$VISUAL"
alias vi='nvim'

# Vim commands in bash
bindkey -v
bindkey "jj" vi-cmd-mode

# Use real backspace instead of vi-backward-delete-char
# https://unix.stackexchange.com/a/206933
bindkey -v '^?' backward-delete-char
bindkey -v '^h' backward-delete-char

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Two sided prompt
PROMPT='%F{red}%n%f@%F{blue}%m%f %F{yellow}%1~%f %# '
#RPROMPT='[%F{yellow}%?%f]'

# TODO: figure how to make this show insert mode?
function zle-line-init zle-keymap-select {
  VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
  #RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $(git_custom_status) $EPS1"
  RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

alias szp="source $HOME/.zshrc"
alias ezp="vi $HOME/.zshrc"

# Always ls with colors
alias ls='ls -G'

unset LSCOLORS

export CLICOLOR  # same as 'alias ls=ls -G' which I also have set
export LSCOLORS=ExFxBxDxCxegedabagacad
