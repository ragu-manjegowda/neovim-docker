#!/usr/bin/env sh

if [ -z "$UID" ]; then
    UID=$(id -u)
fi

if [ -z "$GID" ]; then
    GID=$(id -g)
fi

usermod -u "$UID" neovim
groupmod -g "$GID" neovim
su-exec neovim nvim "$@"
