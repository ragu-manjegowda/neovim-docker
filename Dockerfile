FROM alpine:latest as builder

WORKDIR /mnt/build/ctags

FROM alpine:latest

LABEL \
    maintainer="ragu-manjegowda" \
    url.github="https://github.com/ragu-manjegowda/neovim-docker" \
    url.dockerhub="https://hub.docker.com/r/ragumanjegowda/neovim-docker/"

ENV \
        UID="1000" \
        GID="1000" \
        UNAME="neovim" \
        GNAME="neovim" \
        SHELL="/bin/bash" \
        WORKSPACE="/mnt/workspace" \
    NVIM_CONFIG="/home/neovim/.config/nvim" \
    ENV_DIR="/home/neovim/.local/share/vendorvenv" \
    NVIM_PROVIDER_PYLIB="python3_neovim_provider" \
    PATH="/home/neovim/.local/bin:${PATH}"

RUN \
    # install packages
    apk --no-cache --update upgrade \
    && apk --no-cache add \
    build-base \
    # needed by neovim :CheckHealth to fetch info
    curl \
    # needed to change uid and gid on running container
    shadow \
    # needed for cloning plugins
    git \
    # shell
    bash \
    zsh \
    # needed to install apk packages as neovim user on the container
    sudo \
    # needed to switch user
    su-exec \
    # needed for neovim python3 support
    python3 \
    # python provider for neovim
    py3-pynvim \
    # text editor
    neovim \
    neovim-doc \
    # tools for mason
    npm \
    go \
    clang \
    # rg for telescope
    ripgrep \
    # install build packages
    && apk --no-cache add --virtual build-dependencies \
    python3-dev \
    gcc \
    musl-dev \
    # create user
    && addgroup "${GNAME}" \
    && adduser -D -G "${GNAME}" -g "" -s "${SHELL}" "${UNAME}" \
    && echo "${UNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /home/neovim/.local && mkdir -p /home/neovim/.cache \
    && chown -R ${UNAME}:${GNAME} /home/neovim/.local \
    && chown -R ${UNAME}:${GNAME} /home/neovim/.cache \
    # remove build packages
    && apk del build-dependencies

COPY entrypoint.sh /usr/local/bin/

VOLUME "${WORKSPACE}"
VOLUME "${NVIM_CONFIG}"

ENTRYPOINT ["sh", "/usr/local/bin/entrypoint.sh"]
