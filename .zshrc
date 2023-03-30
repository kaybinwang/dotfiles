# shellcheck shell=bash
#===============================================================================
# .zshrc - zsh configuration
#===============================================================================
# This file uses the generic shell configuration defined in profile.sh. The only
# thing we need to do is to define the hooks that invoked by profile.sh.
#
# Note that we should avoid defining any configuration in this file. This should
# be defined in profile.sh instead.
#===============================================================================

__PROMPT_RESET='%f'
__PROMPT_RED='%F{red}'
__PROMPT_GREEN='%F{green}'
__PROMPT_YELLOW='%F{yellow}'
__PROMPT_BLUE='%F{blue}'
__PROMPT_MAGENTA='%F{magenta}'
__PROMPT_CYAN='%F{cyan}'

__PROMPT_USER='%n'
__PROMPT_HOST='%m'
__PROMPT_CWD='%~'

__PROMPT_EOL='%%'  # requires extra % for escaping

__bind_key_for_history_prefix_search_backward() {
  bindkey "$1" history-beginning-search-backward
}

__bind_key_for_history_prefix_search_forward() {
  bindkey "$1" history-beginning-search-forward
}

__enable_command_completion() {
  autoload -U compinit; compinit
}

__enable_shared_history() {
  setopt share_history
}

# __save_and_reload_history is a no-op since we enabled shared history
__save_and_reload_history() {
  true
}

precmd() {
  __prompt_command
}

source .config/sh/profile.sh
