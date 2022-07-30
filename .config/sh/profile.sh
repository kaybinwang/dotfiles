#===============================================================================
# Table of contents
#===============================================================================
# 1. Sourced Scripts
# 2. Key Bindings
# 3. Settings
# 4. Startup Commands
# 5. Prompt
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

# Source last since it might depend on the above scripts, e.g. __git_complete
source ~/.config/sh/aliases.sh

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
# 4. Startup Commands
#===============================================================================

# Load all ssh keys in keychain for MacOS.
ssh-add -A &>/dev/null

#===============================================================================
# 5. Prompt
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
