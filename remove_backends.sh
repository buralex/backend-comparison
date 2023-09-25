#!/bin/bash

cd ~/backend-comparison/nodejs-comparison
set -o allexport && . ./.env.prod && set +o allexport
docker compose -f compose.yml --project-name $PROJECT_NAME down --volumes

cd ~/backend-comparison/go-comparison
set -o allexport && . ./.env.prod && set +o allexport
docker compose -f compose.yml --project-name $PROJECT_NAME down --volumes

cd ~/backend-comparison/rust-comparison
set -o allexport && . ./.env.prod && set +o allexport
docker compose -f compose.yml --project-name $PROJECT_NAME down --volumes

echo "### Cleaning unused images"
docker image prune --all --force