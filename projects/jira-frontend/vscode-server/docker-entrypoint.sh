#!/bin/bash

# Clone repository
if [ ! -d ~/workspace/.git ]; then
  git clone $GIT_CLONE_URL ~/workspace
fi;

# Install vscode extensions
extensions=("esbenp.prettier-vscode")
for extension in "${extensions[@]}"; do
  code-server --install-extension ${extension}
done

exec "$@"