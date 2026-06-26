#!/usr/bin/env sh

set -euo

. scripts/utils/log.sh
. scripts/utils/system.sh

# ── Version pins (Linux binary installs) ──────────────────────────────────────

NVIM_VERSION="0.10.4"
LUA_LS_VERSION="3.13.6"
YQ_VERSION="4.44.3"

# ── Package lists ──────────────────────────────────────────────────────────────

BREW_REPOS="
"

BREW_PACKAGES="
bash
bash-completion
bat
coreutils
docker
fzf
git
jq
lua-language-server
neovim
ripgrep
shellcheck
tmux
yq
zsh
bash-language-server
kotlin-language-server
pyright
pre-commit
"

BREW_CASKS="
kitty
"

DEBIAN_APT_PACKAGES="
autoconf
automake
bash
bash-completion
bat
build-essential
ca-certificates
cmake
coreutils
curl
file
fzf
git
git-doc
gnupg
jq
libncurses-dev
libssl-dev
libtool
locales
nasm
openssh-client
procps
ripgrep
shellcheck
sudo
tmux
universal-ctags
unzip
wget
zsh
"

ALPINE_APK_PACKAGES="
autoconf
automake
bash
bash-completion
bat
build-base
ca-certificates
cmake
coreutils
ctags
curl
docker
file
fzf
gcc
git
git-doc
jq
libressl
libtool
lua-language-server
nasm
ncurses
neovim
openssh-client
ripgrep
shellcheck
tmux
wget
yq
zsh
"

# ── Binary install helpers (Linux only) ────────────────────────────────────────

install_neovim() {
  log_info "Installing Neovim v${NVIM_VERSION}..."
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)  NVIM_ARCH="x86_64" ;;
    aarch64) NVIM_ARCH="arm64" ;;
    *) log_error "Unsupported arch: $ARCH"; exit 1 ;;
  esac
  curl -fsSL "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-${NVIM_ARCH}.tar.gz" \
    | sudo tar -xzf - -C /usr/local --strip-components=1
}

install_lua_language_server() {
  log_info "Installing lua-language-server v${LUA_LS_VERSION}..."
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)  LLS_ARCH="x64" ;;
    aarch64) LLS_ARCH="arm64" ;;
    *) log_error "Unsupported arch: $ARCH"; exit 1 ;;
  esac
  sudo mkdir -p /usr/local/lib/lua-language-server
  curl -fsSL "https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LS_VERSION}/lua-language-server-${LUA_LS_VERSION}-linux-${LLS_ARCH}.tar.gz" \
    | sudo tar -xzf - -C /usr/local/lib/lua-language-server
  sudo ln -sf /usr/local/lib/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server
}

install_yq() {
  log_info "Installing yq v${YQ_VERSION}..."
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)  YQ_ARCH="amd64" ;;
    aarch64) YQ_ARCH="arm64" ;;
    *) log_error "Unsupported arch: $ARCH"; exit 1 ;;
  esac
  sudo curl -fsSL "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${YQ_ARCH}" \
    -o /usr/local/bin/yq
  sudo chmod +x /usr/local/bin/yq
}

install_docker_cli() {
  log_info "Installing Docker CLI..."
  ARCH=$(dpkg --print-architecture)
  CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  printf "deb [arch=%s signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian %s stable\n" \
    "$ARCH" "$CODENAME" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends docker-ce-cli
}

# ── OS-specific install functions ──────────────────────────────────────────────

install_packages_for_mac_os() {
  if ! command -v brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew already exists. Skipping..."
  fi

  echo "Tapping third-party repositories..."
  # shellcheck disable=SC2086
  echo $BREW_REPOS | xargs brew tap

  echo "Installing packages..."
  # shellcheck disable=SC2086
  echo $BREW_PACKAGES | xargs brew install

  echo "Installing casks..."
  # shellcheck disable=SC2086
  echo $BREW_CASKS | xargs brew install --cask
}

install_packages_for_debian() {
  sudo apt-get update
  # shellcheck disable=SC2086
  echo $DEBIAN_APT_PACKAGES | xargs sudo apt-get install -y --no-install-recommends
  # bat ships as batcat on Debian to avoid a naming conflict
  sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
  printf "en_US.UTF-8 UTF-8\n" | sudo tee -a /etc/locale.gen > /dev/null
  sudo locale-gen
  install_docker_cli
  install_neovim
  install_lua_language_server
  install_yq
}

install_packages_for_alpine() {
  sudo apk upgrade --no-cache
  # shellcheck disable=SC2086
  echo $ALPINE_APK_PACKAGES | xargs sudo apk add --update --no-cache
}

install_packages_for_linux() {
  log_info "Determining Linux distribution..."
  if is_alpine_os; then
    log_info "Using Alpine!"
    install_packages_for_alpine
  elif is_debian_os; then
    log_info "Using Debian!"
    install_packages_for_debian
  else
    log_error "Unsupported Linux distribution"
    exit 1
  fi
}

# ── Main ───────────────────────────────────────────────────────────────────────

install_packages() {
  log_info "Determining which OS to install packages for..."
  if is_mac_os; then
    log_info "Using Mac OS!"
    install_packages_for_mac_os
  elif is_linux_os; then
    log_info "Using Linux!"
    install_packages_for_linux
  else
    log_error "Unknown OS"
    exit 1
  fi
}

install_nav() {
  # TODO: investigate why sudo is required for GHA
  log_info "Installing nav..."
  sudo git clone https://github.com/kaybinwang/nav "$NAV_DIR"
}

install_packages
install_nav
