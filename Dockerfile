FROM debian:bookworm-slim

ARG USER=kevinwang
ARG TTYD_VERSION=1.7.7

# Bootstrap packages needed before install.sh can run
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    sudo \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# ttyd is Docker-specific (exposes the terminal over HTTP) so it lives here
# rather than in install.sh
RUN ARCH=$(dpkg --print-architecture) \
    && case "$ARCH" in \
         amd64) TTYD_ARCH="x86_64" ;; \
         arm64) TTYD_ARCH="aarch64" ;; \
       esac \
    && curl -fsSL "https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/ttyd.${TTYD_ARCH}" \
         -o /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd

RUN groupadd -r ${USER} \
    && groupadd -f docker \
    && useradd -m -g ${USER} -G sudo,docker -s /usr/bin/zsh ${USER} \
    && echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${USER}
WORKDIR /home/${USER}

ARG DOTFILE_DIR=/home/${USER}/projects/dotfiles

COPY --chown=${USER}:${USER} . ${DOTFILE_DIR}
RUN cd ${DOTFILE_DIR} && ./install.sh

# Pre-install neovim plugins (packer).
# Clone packer manually so init.lua skips bootstrap mode and PackerSync runs
# cleanly with the PackerComplete autocmd to wait for it.
RUN git clone --depth=1 https://github.com/wbthomason/packer.nvim \
      /home/${USER}/.local/share/nvim/site/pack/packer/start/packer.nvim \
    && nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync" 2>/dev/null || true

EXPOSE 7681
CMD ["ttyd", "-W", "zsh"]
