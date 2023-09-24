#!/bin/bash

# ============================================
#                  fastify
# ============================================
cd ~/backend-comparison/nodejs-comparison
set -o allexport && . ./.env.prod && set +o allexport
docker compose -f compose.yml --project-name $PROJECT_NAME down --volumes

# ============================================
#                  gin
# ============================================
cd ~/backend-comparison/go-comparison
set -o allexport && . ./.env.prod && set +o allexport
docker compose -f compose.yml --project-name $PROJECT_NAME down --volumes

# ============================================
#                  rust
# ============================================
cd ~/backend-comparison/rust-comparison
set -o allexport && . ./.env.prod && set +o allexport
docker compose -f compose.yml --project-name $PROJECT_NAME down --volumes

# ============================================
#                  common
# ============================================
  echo "### Cleaning unused images"
  docker image prune --all --force