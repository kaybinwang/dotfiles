FROM tsl0922/ttyd:1.7.3-alpine

ARG USER=kevinwang
ARG DOTFILES_REPO=https://github.com/kaybinwang/dotfiles.git
ARG DOTFILES_DIR=/home/$USER/dotfiles

USER root
RUN \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  apk upgrade --no-cache && \
  apk add --update --no-cache \
    sudo \
    autoconf \
    automake \
    libtool \
    nasm \
    ncurses \
    ca-certificates \
    libressl \
    bash-completion \
    cmake \
    ctags \
    file \
    curl \
    build-base \
    gcc \
    coreutils \
    wget \
    neovim \
    git git-doc \
    openssh-client \
    zsh \
    vim \
    tmux \
    docker \
    docker-compose

# create a password-less user and add to wheel group
RUN \
  echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  adduser -D -G wheel $USER && \
  addgroup $USER docker

# switch to the user
USER $USER
WORKDIR /home/$USER

RUN \
  git clone $DOTFILES_REPO $DOTFILES_DIR && \
  cd $DOTFILES_DIR && \
  ./install.sh

CMD []
