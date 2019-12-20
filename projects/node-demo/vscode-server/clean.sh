#!/bin/bash
docker-compose --project-name node-demo-vscode-servergit push github
 down -v --rmi all --remove-orphans