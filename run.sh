#!/bin/bash
# halt script on error
set -e

################################################################################
#################### For MacOS #################################################
################################################################################
if [ "$(uname)" == "Darwin" ]; then
    echo "$(uname) is not supported" >&2
    exit 1

################################################################################
#################### For Linux #################################################
################################################################################
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

        # Check if the container with name "nvim" exists
        if docker ps -a --format '{{.Names}}' | grep -q "^nvim$"; then
            # If new arguments are provided start fresh container
            if [[ $# -gt 0 ]]; then
                docker stop nvim && docker rm nvim
                docker run --name nvim -it -e UID="$(id -u)" -e GID="$(id -g)" \
                -v "${PWD}":/mnt/workspace \
                "ragumanjegowda/neovim-docker:latest" "$@"
            else
                echo "Container 'nvim' exists. Starting the existing container..."
                docker start nvim && docker attach nvim
            fi
        else
            docker run --name nvim -it -e UID="$(id -u)" -e GID="$(id -g)" \
            -v "${PWD}":/mnt/workspace \
            "ragumanjegowda/neovim-docker:latest" "$@"
        fi

################################################################################
# Any other OS
################################################################################
else
    echo "$(uname) is not supported" >&2
    exit 1
fi

