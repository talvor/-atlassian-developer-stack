#!/bin/bash

if [ ! -d ~/data/.git ]; then
  git clone GIT_CLONE_URL ~/data
fi;

exec "$@"