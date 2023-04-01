FROM tsl0922/ttyd:alpine

ARG USER=kevinwang
ARG GROUP=wheel

USER root
RUN \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  apk upgrade --no-cache && \
  apk add --update --no-cache \
    docker \
    sudo

# create a password-less user and add to wheel group
RUN \
  echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  adduser -D -G $GROUP $USER && \
  addgroup $USER docker

# update login shell to use zsh
RUN sed -i 's/\/bin\/ash/\/bin\/zsh/g' /etc/passwd

# switch to the user
USER $USER
WORKDIR /home/$USER
# TODO: figure out how to avoid hardcoding this path
ARG DOTFILE_DIR=/home/$USER/projects/dotfiles

COPY --chown=$USER:$GROUP . $DOTFILE_DIR
RUN cd $DOTFILE_DIR && ./install.sh

CMD []
