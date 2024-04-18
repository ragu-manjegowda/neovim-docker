#!/usr/bin/env sh

usermod -u "$(id -u)" neovim
groupmod -g "$(id -g)" neovim
echo "Updating plugins"
su-exec neovim nvim --headless -c "Lazy! sync" +qa &> /dev/null
echo "starting nvim"
su-exec neovim nvim "$@"
