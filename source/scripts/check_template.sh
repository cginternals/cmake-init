#!/bin/bash

WORKING_DIRECTORY=`pwd`

if [ $# -lt 2 ]; then
  echo "$0 has to be called using two parameters"
  exit 1
fi

TEMPLATE_PATH="$1"
PROJECT_PATH="$2"

cd $WORKING_DIRECTORY
cd $TEMPLATE_PATH

CMAKE_INIT_SHA1_HASH=`git log -n 1 --pretty="%H"`

cd $WORKING_DIRECTORY
cd $PROJECT_PATH

PROJECT_SHA1_HASH=`git log --oneline | grep -i "cmake-init" | grep -o -E "[0-9a-f]{40}" | head -n 1`

if [ "$CMAKE_INIT_SHA1_HASH" == "$PROJECT_SHA1_HASH" ]; then
  echo "cmake-init template is up-to-date ($CMAKE_INIT_SHA1_HASH)"
else
  echo "cmake-init template needs an update: https://github.com/cginternals/cmake-init/compare/$PROJECT_SHA1_HASH...master"
fi
