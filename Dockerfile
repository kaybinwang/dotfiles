FROM alpine:latest

ARG user=kevinwang
ARG group=wheel
ARG uid=1000
ARG dotfiles_repo=https://github.com/kaybinwang/dotfiles.git

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
  adduser -D -G wheel ${user} && \
  addgroup ${user} docker
WORKDIR /home/${user}

ENV DOTFILES_DIR="/home/${user}/.dotfiles"

RUN git clone ${dotfiles_repo} ${DOTFILES_DIR}

  # chown -R ${user}:${group} /home/${user}/dotfiles

# RUN chmod u+x "${DOTFILES_DIR}/install.sh"

USER ${user}

RUN cd $DOTFILES_DIR && ./install.sh

ENV HISTFILE=/home/${user}/.cache/.zsh_history

CMD []

ENTRYPOINT [ "/bin/zsh" ]
