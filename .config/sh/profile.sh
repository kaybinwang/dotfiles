# shellcheck shell=bash
#===============================================================================
# profile.sh - a generic shell configuration
#===============================================================================
# This file contains an abstract configuration for a shell. It defines how the
# shell should be configured, but leaves out most of the implementation. This is
# because every shell has a different way of configuring things and the syntax
# is usually not compatible. We use this abstract configuration so that we can
# expect similar functionality, regardless of the shell we're using.
# 
# In order to use this configuration, you need to provide an implementation for
# all the hooks that are used in this file, e.g. __enable_command_completion,
# before sourcing.
#
# Sections:
# 0. PATH Boostrap
# 1. Source Scripts
# 2. Key Bindings
# 3. Settings
# 4. Prompt
# 5. Run Commands
#===============================================================================

#===============================================================================
# 0. Bootstrap
#
# Needs to be executed before everything else since it mucks w/ the environment.
# For example, setting up Homebrew so that all installed packages are available
# in the PATH.
#===============================================================================

source ~/.config/sh/bootstrap.sh

#===============================================================================
# 1. Source Scripts
#
# Source the required scripts, followed by optional scripts. Note that order
# doesn't necessarily matter since each script should be self-contained.
#===============================================================================

source ~/.config/sh/env.sh
source ~/.config/sh/aliases.sh
source ~/.config/sh/helpers.sh

# TODO: install nav to a hardcoded place
__source_if_exists "$HOME/projects/nav/nav.sh"
__source_if_exists ~/.config/sh/work.sh

#===============================================================================
# 2. Key Bindings
#===============================================================================

# Prefix search using ^P and ^N
__bind_key_for_history_prefix_search_backward '^p'
__bind_key_for_history_prefix_search_forward '^n'

#===============================================================================
# 3. Settings
#===============================================================================

__enable_command_completion
__enable_shared_history

#===============================================================================
# 4. Prompt
#===============================================================================

# This function is executed after each command and it will do the following:
#   - Update the prompt to include additional information such as,
#     - the python virtual env, if one is activated
#     - the exit status of the previous command
#     - the git branch, if inside an git directory
#   - Flush the current shell's history session and reloads it
__prompt_command() {
    # This needs to be first to capture exit code of previous command
    local -r exit_code="$?"

    # Show python virtual env if activated
    if [ "$VIRTUAL_ENV" != "" ]; then
      # Strip out the path and just leave the env name
      local venv="${__PROMPT_RESET}(${VIRTUAL_ENV##*/}) "
    else
      local venv=''
    fi

    # Show if previous command failed
    if [ $exit_code != 0 ]; then
        local command_result="${__PROMPT_RED}[✘]${__PROMPT_RESET}"
    else
        local command_result="${__PROMPT_GREEN}[✔]${__PROMPT_RESET}"
    fi

    local -r user="${__PROMPT_YELLOW}${__PROMPT_USER}${__PROMPT_RESET}"
    local -r host="${__PROMPT_GREEN}${__PROMPT_HOST}${__PROMPT_RESET}"
    local -r cwd="${__PROMPT_BLUE}${__PROMPT_CWD}${__PROMPT_RESET}"

    # Show working git branch if applicable
    local git_branch=''
    if command -v git &>/dev/null; then
      git_branch="$(__parse_git_branch)"
      if [ -n "$git_branch" ]; then
        git_branch="${__PROMPT_MAGENTA}(${git_branch})${__PROMPT_RESET} "
      fi
    fi

    # Optional parameters, e.g. venv, git_branch, will always be include a
    # trailing space to preserve formatting
    PS1="${venv}${command_result} ${user}@${host}:${cwd} ${git_branch}${__PROMPT_EOL} "

    # Force prompt to write history after every command.
    # This way running command X in shell 1 shows in the history of shell 2.
    # http://superuser.com/questions/20900/bash-history-loss
    __save_and_reload_history
}

__parse_git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

#===============================================================================
# 5. Run Commands
#===============================================================================

# Load all ssh keys in keychain for MacOS.
if [ "$(uname)" = "Darwin" ]; then
  ssh-add -A &>/dev/null
fi
