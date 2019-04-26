################################################################################
# Table of contents
################################################################################
# 1. Environment Variables
# 2. Key Bindings
# 3. Sourced Scripts
# 4. Helper Functions
################################################################################


################################################################################
# 1. Environment Variables
################################################################################

export CLICOLOR=1
export LIGHT_COLORS=false

if [ $LIGHT_COLORS ]; then
  export LSCOLORS=ExFxBxDxCxegedabagacad
else
  export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
fi

if command -v nvim &>/dev/null; then
  export VISUAL=nvim
elif command -v vim &>/dev/null; then
  export VISUAL=vim
fi
export EDITOR="$VISUAL"

# Special paths
export PROJECT_PERSONAL="$HOME/projects/personal"
export PROJECT_WORK="$HOME/projects/work"
export GOPATH="$PERSONAL_PROJECT/go"
export NVM_DIR="$HOME/.nvm"

# Extend $PATH
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export PATH=$GOPATH/bin:$PATH

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

PROMPT_COMMAND=__prompt_command


################################################################################
# 2. Key Bindings
################################################################################

# Load all ssh keys in keychain for MacOS.
ssh-add -A &>/dev/null

# Disable XON/XOFF since it sometimes conflicts with ^s in bash
# stty -ixoff
# stty stop undef
# stty start undef

# Prefix search using ^P and ^N
bind '"\C-P":history-search-backward'
bind '"\C-N":history-search-forward'


################################################################################
# 3. Sourced Scripts
################################################################################

# sourcing kitty terminal completions
if command -v kitty &>/dev/null; then
  source <(kitty + complete setup bash)
fi

# sourcing nvm and completions
[ -s "$NVM_DIR/nvm.sh " ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# sourcing bash completions from homebrew
if [ -s /usr/local/etc/bash_completion ]; then
  source /usr/local/etc/bash_completion
elif command -v brew &>/dev/null; then
  if [ -s "$(brew --prefix)/etc/bash_completion" ]; then
    source "$(brew --prefix)/etc/bash_completion"
  fi
fi

# Source last since it might depend on the above scripts, e.g. __git_complete
source ~/.bash_aliases
source ~/.bash_extras


################################################################################
# 4. Helper Functions
################################################################################

# This function is executed after each command and it will do the following:
#   - Update the prompt to include additional information such as,
#     - the python virtual env, if one is activated
#     - the exit status of the previous command
#     - the git branch, if inside an git directory
#   - Flush the current shell's history session and reloads it
function __prompt_command() {
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
        git_branch="${purple}${git_branch}${reset} "
      fi
    fi

    # Optional parameters, e.g. venv, git_branch, will always be include a
    # trailing space to preserve formatting
    PS1="${venv}${status} ${user}@${host}:${cwd} ${git_branch}$ "

    __save_and_reload_history
}

function __parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function __save_and_reload_history() {
  history -a # immediately append the current session to ~/.bash_history
  history -c # clear the current session
  history -r # reload the session from ~/.bash_history
}
