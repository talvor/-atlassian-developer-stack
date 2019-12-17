#!/bin/bash

if [ ! -d ~/workspace:/.git ]; then
  git clone $GIT_CLONE_URL ~/workspace:
fi;

exec "$@"