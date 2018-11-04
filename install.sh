#!/bin/bash

################################################################################
#
# dfsetup: Automated dotfile setup and system configuration.
#
# TODO: opener about setting up dev environment.
#
# This script is used for keeping configuration files in $HOME in sync with the
# ones that are in this directory.
#
# TODO: document linking, system setup, git setup, backing up existing files.
#
################################################################################

# TODO: maybe delete this

# Files to be symlinked from script directory into /usr/local/bin
# Please keep make all binaries siblings to the script
declare -r BINS='
dotfiles
'

# Files to be symlinked from script directory into $HOME
declare -r DOTFILES='
.env
.zshrc
.bash_profile
.bash_aliases
.bash_extras
.gitconfig
.gitconfig-personal
.gitconfig-work
.tern-config
.tmux.conf
.config/nvim/init.vim
.config/kitty/kitty.conf
.chunkwmrc
.skhdrc
.vimrc
'

PROGRAM="$(basename "$0")"
declare -r PROGRAM

# Global variables set by the options passed into the script.
declare REINSTALL=
declare DEBUG=

# TODO: make support multiple creations
function usage() {
  cat <<EOF
Usage: $PROGRAM [-h | -l | -c package | -dr package ... ]

Options:
	-h	Prints this message.

	-d	Enables debug mode.

	-r	Reinstalls the packages.

	-l	Lists all available packages.

	-u	Updates the dotfiles and installs new configuration.

	-c	package
		Creates a template for a new package.

EOF
}

# On EXIT clean up of exported variables.
function cleanup() {
  res="$?"
  unset REINSTALL
  unset DEBUG
  if [ $res -ne 0 ]; then
    printf_error "Error: $res"
  fi
}

# On SIGTERM kill all forked processes.
function teardown() {
  pkill -g 0
}

function setup_system() {
  echo 'Logging in as system root...'
  sudo -v
  softwareupdate -ia
  systemsetup -setremotelogin on
  xcode-select --install 2>/dev/null
  # TODO: remap ctrl key if possible
  # TODO: battery percent
  # TODO: show bluetooth
}

function install_brew() {
  command -v brew || /usr/bin/ruby -e "$(curl -fsSL
    https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function prompt_user() {
  local input
  local response
  while true; do
    echo -n "$1: "
    read -r input
    echo -n "Is $input correct? [y/N]: "
    read -r response
    if [ -z "$response" ] || [ "$response" == "y" ]; then
      break
    fi
  done
  __="$input"
}

function confirm_user() {
  local response
  echo -n "$1 [y/N]: "
  read -r response
  if [ -z "$response" ] || [ "$response" == "y" ]; then
    return 0
  fi
  return 1
}

function prompt_user_no_confirm() {
  local input
  local response
  echo -n "$1: "
  read -r input
  __="$input"
}

function setup_github() {
  # TODO: id_rsa is the default and we are using this to setup a default
  # personal identity. In the future, we should try to generalize this function
  # for the Host, Hostname, IdentityFile.
  local ssh_key="$HOME/.ssh/id_rsa"

  echo 'Creating a new SSH key for GitHub...'

  while [ -e "$ssh_key" ]; do
    echo "You already have an SSH key here: $ssh_key"
    if confirm_user 'Would you like to create another one?'; then
      prompt_user 'Please enter an SSH key location'
      ssh_key="${__}"
    else
      return 0
    fi
  done

  github_generate_ssh_key "$ssh_key" || return $?
  github_upload_ssh_key "$ssh_key.pub" || return $?
}


################################################################################
#
# github_generate_ssh_key: Creates an public/private SSH keypair for GitHub.
#
# Env:
#   DEBUG (bool)
#
# Arguments:
#   Private SSH key location (string)
#
# Returns an error if:
#   The IdentityFile already exists.
#
################################################################################
function github_generate_ssh_key() {
  prompt_user 'Please enter your GitHub email address and press [Enter]'
  local -r email_address="${__}"

  local -r ssh_key="$1"
  local -r ssh_dir="$(dirname "$ssh_key")"
  local -r ssh_config="$ssh_dir/config"
  if [ ! -f "$ssh_key" ]; then
    mkdir -p "$ssh_dir"
    ssh-keygen -t rsa -b 4096 -f "$ssh_key" -C "$email_address"
    eval "$(ssh-agent -s)" &>/dev/null
    ssh-add -K "$ssh_key"

    # MacOS 10.12.2 or later only
    cat <<EOF >> "$ssh_config"
Host github.com
  HostName github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ${ssh_key}
EOF
  else
    print_error "File $ssh_key already exists."
  fi
}

function date_rfc() {
  date -u +%Y-%m-%dT%H:%M:%SZ
}

function github_upload_ssh_key_api() {
  local -r pub_file="$1"
  if [ -z "$pub_file" ]; then
    print_error 'Please input a file with github_upload_ssh_key_api'
    return 1
  fi

  prompt_user 'Please enter your Github username and press [Enter]'
  local -r username="${__}"

  local -r title="$(whoami)@$(hostname)_$(date_rfc)"
  local -r pub_key="$(cat "$pub_file")"

  if ! curl --fail -u "$username" \
    --data "{\"title\":\"$title\",\"key\":\"$pub_key\"}" \
    https://api.github.com/user/keys
  then
    return 1
  fi

  print_info "Created SSH key on GitHub with $title"
  return 0
}

function github_upload_ssh_key() {
  local -r pub_file="$1"
  if [ -z "$pub_file" ]; then
    print_error 'Please input a file with github_upload_ssh_key_api'
    return 1
  fi

  if repeat_try github_upload_ssh_key_api "$pub_file"; then
    return 0
  fi

  pbcopy < "$pub_file"
  echo "Copied SSH public key from $pub_file to clipboard"

  echo "Opening GitHub Settings page..."
  echo "Please login and paste your SSH key."
  open https://github.com/settings/keys
  prompt_user_no_confirm 'Press [Enter] to continue'
  return 0
}

function repeat_try() {
  local response
  while :
  do
    if eval "$@"; then
      break
    fi
    echo -n 'Try again? [y/N]: '
    read -r response
    if [ "$response" == "N" ]; then
      return 1
    fi
  done
  return 0
}

# TODO: move into it's own package
function install_git() {
  brew install git
}

#
# symlink $1
#
# Creates a symlink from dst -> src
#
# If dst already exists, then it is backed up to 
# (dirname backup_dir/src) if backup_dir provided
#
# please use relative paths
#
function symlink() {
  local -r dst="$1"
  local -r src="$2"
  local -r backup_root="$3"
  print_verbose "Creating symlink $dst -> $src"
  if [ -h "$dst" ]; then
    # Remove old symlink
    rm "$dst"
  fi
  if [ -e "$dst" ]; then
    # Only backup if a backup directory was provided
    if [ -z "$backup_root" ]; then
      print_error "Unable to symlink. File $dst already exists."
      return 1
    fi
    local -r backup_dir="$(dirname "$backup_root/$dotfile")"
    if [ ! -d "$backup_dir" ]; then
      print_debug "Backup directory DNE. Creating $backup_dir ..."
      mkdir -p "$backup_dir"
    fi
    print_warning "File already exists. Backing up $dst -> $backup_dir/$dst"
    mv "$dst" "$backup_dir"
  fi

  # Check to make sure the parent directories for src exist before linking
  local -r dst_dir="$(dirname "$dst")"
  if [ ! -d "$dst_dir" ]; then
    print_debug "Creating directory $dst_dir"
  fi
  mkdir -p "$dst_dir"
  ln -s "$src" "$dst"
}

# TODO: document and fix relative symlinks
function setup_dotfiles() {
  pushd_debug "$DOTFILE_PATH"
  print_info 'Setting up dotfiles...'
  local -r backup_dir="${HOME}/.dotfiles_backup/$(date_rfc)"

  local dotfile
  while read -r dotfile; do
    [ -z "$dotfile" ] && continue

    local src="$HOME/$dotfile"
    local dst="$DOTFILE_PATH/$dotfile"
    symlink "$src" "$dst" "$backup_dir"
  done <<< "$DOTFILES"

  print_info 'Finished setting up dotfiles!'
  popd_debug
}

function pushd_debug() {
  local -r path="$1"
  if ! pushd "$path" >/dev/null; then
    print_error "Unable to switch CWD to $path"
  fi
  print_debug "Switched to CWD to $path"
}

function popd_debug() {
  if ! local -r path="$(popd)"; then
    print_error "Unable to switch CWD"
  fi
  print_debug "Switched to CWD to $path"
}

function setup_bin() {
  pushd_debug "$DOTFILE_PATH"
  print_info 'Setting up binaries...'

  local bin
  local from
  local to
  while read -r bin; do
    [ -z "$bin" ] && continue

    from="/usr/local/bin/$(basename "$bin")"
    to="$(abs_dirname "$bin")/$(basename "$bin")"
    symlink "$from" "$to"
  done <<< "$BINS"

  print_info 'Finished linking binaries to /usr/local/bin'
  popd_debug
}

# Outputs the package cache path
function pkg_cache() {
  local -r pkg="$1"
  if [ -z "$pkg" ]; then
    print_error 'pkg_cache requires a package name.'
  fi
  echo "$DOTFILE_PATH/pkg/$pkg/.setup"
}

# Outputs the package setup path
function pkg_script() {
  local -r pkg="$1"
  if [ -z "$pkg" ]; then
    print_error 'pkg_script requires a package name.'
  fi
  echo "$DOTFILE_PATH/pkg/$pkg/setup"
}

################################################################################
#
# create: Takes a package name and generates a template setup file at
#
# $DOTFILE_PATH/pkg/$pkg/setup (see pkg_name for details).
#
# Env:
#   DOTFILE_PATH (string)
#   DEBUG        (bool)
#
# Arguments:
#   pkg (string)
#
# Returns an error if:
#   pkg's setup already exists
#
################################################################################
function create() {
  local -r pkg="$1"
  if [ -z "$pkg" ]; then
    print_error "Please supply a package name."
    return 1
  fi
  local -r script="$(pkg_script "$pkg")"
  if [ -e "$script" ]; then
    print_error "$pkg already exists."
    return 1
  fi
  mkdir -p "$(dirname "$script")"
  touch "$script"
  chmod u+x "$script"
  cat <<EOM > "$script"
#!/bin/bash

###############################################################################
#
# $pkg
#
# Generated by dfsetup using template v0.0.3.
#
# Do not execute this script directly. It should only be executed from within
# dfsetup.
#
# If you want to only install $pkg, then execute 'dfsetup $pkg'.
#
###############################################################################

set -e

source ./util/brew.sh
source ./util/dirname.sh
source ./util/print.sh

function install() {
}

function main() {
  install
}

main "\$@"
EOM
  print_info "Created package $pkg at $(abs_dirname "$script")"
}

################################################################################
#
# setup: Takes a package name and executes an executable located at
#
# $DOTFILE_PATH/pkg/$pkg/setup (see pkg_name for details).
#
# Upon success, we create an empty sibling file called .setup that marks that
# the package has installed successfully. This prevents the package from being
# executed through setup for future calls.
#
# If REINSTALL is set, then the provided package will reinstall, regardless of
# the .setup file.
#
# Env:
#   DOTFILE_PATH (string)
#   REINSTALL    (bool)
#   DEBUG        (bool)
#
# Arguments:
#   pkg (string)
#
# Returns an error if:
#   setup does not exist,
#   setup does not have executable permissions,
#   setup failed on execution
#
################################################################################
function setup() {
  local -r pkg="$1"
  local -r script="$(pkg_script "$pkg")"
  local -r cache="$(pkg_cache "$pkg")"

  print_info "Installing package $pkg..."

  if [ ! -f "$script" ]; then
    print_error "Unable to find package $pkg."
    return 1
  fi
  if [ ! -x "$script" ]; then
    print_error "$pkg is not an executable."
    return 1
  fi
  if [ ! "$REINSTALL" ] && [ -e "$cache" ]; then
    print_warning "$pkg already installed. Reinstall with '$PROGRAM -r $pkg'"
    return 0
  fi
  print_debug "Executing $script..."
  if ! eval "$script"; then
    return 1
  fi

  print_debug "Created cache file at $cache..."
  touch "$cache"
  print_info "Sucessfully installed package $pkg"
  return 0
}

function usage_install() {
  if [ "$#" -eq 0 ]; then
    return 0
  fi
  for cmd in "$@"; do
    shift
    case "$cmd" in
      list)
        ;;
      *)
        break
        ;;
    esac
  done

  parse_args "$@"
}

function parse_cmd() {
  if [ "$#" -eq 0 ]; then
    return 1
  fi

  local -r parent_cmd="$1"
  shift

  if [ "$#" -eq 0 ]; then
    echo "no argsuments passed to $parent_cmd"
    return 0
  fi

  local -r cmd="$1"
  shift
  echo "Command is $cmd "
  case "$cmd" in
    *)
      if "parse_cmd $cmd $*"; then
        return 0
      fi
      return 1
      ;;
  esac
}

function parse_args() {
  if [ "$#" -eq 0 ]; then
    usage
    exit 0
  fi

  # Shift through each argument and delegate to next parser
  local -r cmd="$1"
  case "$cmd" in
    help)
      if "usage_$cmd"; then
        return 0
      fi
      return 1
      ;;
    *)
      if parse_cmd $*; then
        return 0
      fi
      return 1
      ;;
  esac
}

function bootstrap() {
  # Bootstrap DOTFILE_PATH on the first run and store it into .bash_extras.
  # Also export DOTFILE_PATH so that it's available to the script.
  if [ -z "$DOTFILE_PATH" ] || [ ! -e "$DOTFILE_PATH/.bash_extras" ]; then
    source util/dirname.sh
    source util/print.sh
    print_debug 'First time executing...'

    # abs_dirname resolves all symlinks and relative paths
    DOTFILE_PATH="$(abs_dirname "$0")"
    export DOTFILE_PATH
    local -r bash_extras="$DOTFILE_PATH/.bash_extras"
    echo '#!/bin/bash' > "$bash_extras"
    echo "export DOTFILE_PATH=$DOTFILE_PATH" >> "$bash_extras"

    # One time configuration setups
    #setup_github && \
      #setup_system && \
      setup_dotfiles && \
      setup_bin
  else
    source "$DOTFILE_PATH/util/dirname.sh"
    source "$DOTFILE_PATH/util/print.sh"
  fi
}

################################################################################
#
# main: Main entry point for dfsetup.
#
# If DOTFILE_PATH is not set, then main will set it to the absolute directory
# that this script lives in, resolving all symlinks and relative paths. It will
# also append the variable to .bash_extras and export it as a global.
#
# If REINSTALL is set, then the provided packages will reinstall even if they
# already have.
#
# If DEBUG is set, then the debugging output will be sent to stdout.
#
# Env:
#   DOTFILE_PATH (optional string)
#   REINSTALL    (bool)
#   DEBUG        (bool)
#
# Arguments:
#   A list of packages (string[])
#
# Returns an error if:
#   Setup of any of the packages fail.
#
################################################################################
function main() {

  # Handles first time execution and resolving imports.
  # This must be called first.
  bootstrap

  #parse_args "$@"

  # Parse options and shift to real arguments
  while getopts "sdrlhc:" o; do
    case "$o" in
      r)
        REINSTALL=true
        ;;
      d)
        DEBUG=true
        export DEBUG
        ;;
      s)
        setup_dotfiles
        setup_bin
        exit 0
        ;;
      c)
        create "${OPTARG}"
        exit 0
        ;;
      l)
        #TODO: list all available packages using pyscript
        exit 0
        ;;
      h)
        usage
        exit 0
        ;;
      *)
        echo "Unrecognized option: $o"
        exit 1
        ;;
    esac
  done
  shift $((OPTIND-1))

  print_debug "DOTFILE_PATH=$DOTFILE_PATH"

  # Source bash profile to reflect changes, e.g. GOPATH is now set up
  # TODO: fix bash_profile to not bork on missing commands
  source "$HOME/.bash_profile" &>/dev/null

  # TODO: setup better ?? dep tree idk...
  local pkg
  for pkg in "$@"; do
    setup "$pkg"
  done
  brew upgrade
  setup langs/golang 
  setup langs/python 
  setup langs/javascript 
  setup apps/iterm2 neovim

  # Source bash profile to reflect changes post install.
  source "$HOME/.bash_profile" &>/dev/null
}

# Trap before any possible exits
trap teardown SIGTERM
trap cleanup EXIT

#if [ "$#" -eq 0 ]; then
  #usage
  #exit 0
#fi

main "$@"