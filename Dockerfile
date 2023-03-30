FROM tsl0922/ttyd:1.7.3-alpine

ARG USER=kevinwang

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
  adduser -D -G wheel $USER && \
  addgroup $USER docker

# update login shell to use zsh
RUN sed -i 's/\/bin\/ash/\/bin\/zsh/g' /etc/passwd

# switch to the user
USER $USER
WORKDIR /home/$USER

COPY . .
RUN ./install.sh

CMD []
