#!/bin/bash
# halt script on error
set -e

################################################################################
#################### Build Image ###############################################
################################################################################

# Define the image name and tag
IMAGE_NAME="neovim-docker"
TAG="test"

# Check if the image with the specified tag exists
if docker inspect "$IMAGE_NAME:$TAG" &> /dev/null; then
    # If the image exists, check if there's a container with the same image
    CONTAINER_ID=$(docker ps -aqf "ancestor=$IMAGE_NAME:$TAG")
    if [ -n "$CONTAINER_ID" ]; then
        # If a container exists, stop and remove it
        echo "Stopping and removing container $CONTAINER_ID..."
        docker stop "$CONTAINER_ID" && docker rm "$CONTAINER_ID"
    fi

    # # Remove the image with the specified tag
    # echo "Removing existing image $IMAGE_NAME:$TAG..."
    # docker rmi "$IMAGE_NAME:$TAG"
fi

docker build -t $IMAGE_NAME:$TAG .

################################################################################
#################### Run the built image to test locally #######################
################################################################################

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

    eval docker run --rm -it -e UID="$(id -u)" -e GID="$(id -g)" \
    -v "${PWD}":/mnt/workspace \
    "neovim-docker:test" \

################################################################################
# Any other OS
################################################################################
else
    echo "$(uname) is not supported" >&2
    exit 1
fi
