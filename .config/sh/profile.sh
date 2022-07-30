#===============================================================================
# Table of contents
#===============================================================================
# 1. Sourced Scripts
# 2. Key Bindings
# 3. Interface
# 4. Execute Commands
# 5. Helper Functions
#===============================================================================

#===============================================================================
# 1. Sourced Scripts
#===============================================================================

source ~/.config/sh/env.sh
source ~/.config/sh/helpers.sh

# sourcing nvm and completions
__source_if_exists "$NVM_DIR/nvm.sh"
__source_if_exists "$NVM_DIR/bash_completion"

__source_if_exists ~/.config/sh/work.sh

# sourcing bash completions from homebrew
if command -v brew &>/dev/null; then
  __source_if_exists "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi

# Source last since it might depend on the above scripts, e.g. __git_complete
source ~/.config/sh/aliases.sh

#===============================================================================
# 2. Key Bindings
#===============================================================================

# Prefix search using ^P and ^N
__enable_history_search_with_prefix

#===============================================================================
# 3. Interface
#===============================================================================

PROMPT_COMMAND=__prompt_command

#===============================================================================
# 4. Execute Commands
#===============================================================================

# Load all ssh keys in keychain for MacOS.
ssh-add -A &>/dev/null

#===============================================================================
# 5. Helper Functions
#===============================================================================

# This function is executed after each command and it will do the following:
#   - Update the prompt to include additional information such as,
#     - the python virtual env, if one is activated
#     - the exit status of the previous command
#     - the git branch, if inside an git directory
#   - Flush the current shell's history session and reloads it
__prompt_command() {
    # This needs to be first to capture exit code of previous command
    local EXIT="$?"

    echo "$(date +%Y-%m-%d--%H-%M-%S) $(hostname) $PWD $(history 1)" >> ~/.full_history

    local reset='\[\e[0m\]'
    local red='\[\e[0;31m\]'
    local light_red='\[\e[1;31m\]'
    local green='\[\e[0;32m\]'
    local yellow='\[\e[0;33m\]'
    local light_yellow='\[\e[1;33m\]'
    local blue='\[\e[0;34m\]'
    local light_blue='\[\e[1;34m\]'
    local purple='\[\e[0;35m\]'
    local light_purple='\[\e[1;35m\]'
    local cyan='\[\e[0;36m\]'
    local light_cyan='\[\e[1;36m\]'

    # Show python virtual env if activated
    if [ "$VIRTUAL_ENV" != "" ]; then
      # Strip out the path and just leave the env name
      local venv="${reset}(${VIRTUAL_ENV##*/}) "
    else
      local venv=''
    fi

    # Show if previous command failed
    if [ $EXIT != 0 ]; then
        local status="${red}[✘]${reset}"
    else
        local status="${green}[✔]${reset}"
    fi

    local user="${yellow}\u${reset}"
    local host="${green}\H${reset}"
    local cwd="${light_blue}\w${reset}"

    # Show working git branch if applicable
    local git_branch=''
    if command -v git &>/dev/null; then
      git_branch="$(__parse_git_branch)"
      if [ -n "$git_branch" ]; then
        git_branch="${purple}(${git_branch})${reset} "
      fi
    fi

    # Optional parameters, e.g. venv, git_branch, will always be include a
    # trailing space to preserve formatting
    PS1="${venv}${status} ${user}@${host}:${cwd} ${git_branch}$ "

    __save_and_reload_history
}

__parse_git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

__save_and_reload_history() {
  history -a # immediately append the current session to ~/.bash_history
  history -c # clear the current session
  history -r # reload the session from ~/.bash_history
}
