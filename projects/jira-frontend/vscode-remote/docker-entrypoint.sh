#!/bin/bash

# Clone repository
if [ ! -d ~/workspace/.git ]; then
  git clone $GIT_CLONE_URL ~/workspace
fi;

exec "$@"