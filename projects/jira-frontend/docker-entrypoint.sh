#!/bin/bash

if [ ! -d ~/data/.git ]; then
  git clone git@$GIT_REPO ~/data
fi;

exec "$@"