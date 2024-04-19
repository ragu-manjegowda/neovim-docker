#!/usr/bin/env sh

usermod -u "$(id -u)" neovim
groupmod -g "$(id -g)" neovim
su-exec neovim nvim "$@"
