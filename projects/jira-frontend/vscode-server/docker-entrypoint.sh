#!/bin/bash

# Clone repository
if [ ! -d ~/data/.git ]; then
  git clone $GIT_CLONE_URL ~/data
fi;

# Install vscode extensions
extensions=("esbenp.prettier-vscode")
for extension in "${extensions[@]}"; do
  code-server --install-extension ${extension}
done

exec "$@"