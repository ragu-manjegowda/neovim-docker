#!/bin/sh

# Script takes no arguments
if [ $# -ne 0 ]
  then
    echo "argument error, usage: './push.sh' "
    exit 1
fi

dt=$(date '+%Y%m%d%H%M%S');

docker login -u=ragumanjegowda
docker tag neovim-docker:test ragumanjegowda/neovim-docker:latest
docker tag ragumanjegowda/neovim-docker:latest "ragumanjegowda/neovim-docker:$dt"

docker push "ragumanjegowda/neovim-docker:$dt"
docker push ragumanjegowda/neovim-docker:latest
