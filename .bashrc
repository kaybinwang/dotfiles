#===============================================================================
# .bashrc - bash configuration
#===============================================================================
# This file uses the generic shell configuration defined in profile.sh. The only
# thing we need to do is to define the hooks that invoked by profile.sh.
#
# Note that we should avoid defining any configuration in this file. This should
# be defined in profile.sh instead.
#===============================================================================

__PROMPT_RESET='\[\e[0m\]'
__PROMPT_RED='\[\e[0;31m\]'
__PROMPT_GREEN='\[\e[0;32m\]'
__PROMPT_YELLOW='\[\e[0;33m\]'
__PROMPT_BLUE='\[\e[0;34m\]'
__PROMPT_MAGENTA='\[\e[0;35m\]'
__PROMPT_CYAN='\[\e[0;36m\]'

__PROMPT_USER='\u'
__PROMPT_HOST='\H'
__PROMPT_CWD='\w'

__PROMPT_EOL='$'

__bind_key_for_history_prefix_search_backward() {
  local -r keybinding="${1//^/\C-}"  # replaces ^ with \C-
  bind "\"$keybinding\":history-search-backward"
}

__bind_key_for_history_prefix_search_forward() {
  local -r keybinding="${1//^/\C-}"  # replaces ^ with \C-
  bind "\"$keybinding\":history-search-forward"
}

__enable_command_completion() {
  if command -v brew &>/dev/null; then
    __source_if_exists "$(brew --prefix)/etc/profile.d/bash_completion.sh"
  else
    __print_warning "bash-completion is not installed."
  fi
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
}

# __enable_shared_history is a no-op since we manually save and reload the history
__enable_shared_history() {
  return
}

__save_and_reload_history() {
  history -a # immediately append the current session to history file
  history -r # reload the history file into the current session
}

PROMPT_COMMAND=__prompt_command

source ~/.config/sh/profile.sh
