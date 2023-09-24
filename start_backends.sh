#!/bin/bash

# Parsing passed arguments (example: sh some_script.sh --somearg true)
# https://unix.stackexchange.com/a/388038
while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        v="${1/--/}"
        declare $v="$2"
   fi
  shift
done

check_app_status() {
  local app_url=$1

  while true; do
    response=$(curl -s -o /dev/null -w "%{http_code}" $app_url)
    if [ "$response" = "200" ]; then
      echo "app is up and running!"
      break
    else
      echo "app is not responding yet. Waiting..."
      sleep 2
    fi
  done
}

if [ "$nodejs" == "true" ]; then
  cd ~/backend-comparison/nodejs-comparison
  cp .env.example .env.prod
  sed -i.bak "s/DEPLOY_ENV=.*/DEPLOY_ENV=prod/" .env.prod
  sed -i.bak "s/POSTGRES_HOST=.*/POSTGRES_HOST=postgres-db/" .env.prod
  sed -i.bak "s/POSTGRES_PORT=.*/POSTGRES_PORT=5432/" .env.prod
  set -o allexport && . ./.env.prod && set +o allexport

  docker compose -f compose.yml --project-name $PROJECT_NAME up --detach --pull always

  check_app_status "http://localhost:$MAIN_API_SERVICE_PORT/ping"

  curl http://localhost:$MAIN_API_SERVICE_PORT/helpers/seed
fi

if [ "$go" == "true" ]; then
  cd ~/backend-comparison/go-comparison
  cp .env.example .env.prod
  sed -i.bak "s/DEPLOY_ENV=.*/DEPLOY_ENV=prod/" .env.prod
  sed -i.bak "s/POSTGRES_HOST=.*/POSTGRES_HOST=postgres-db/" .env.prod
  sed -i.bak "s/POSTGRES_PORT=.*/POSTGRES_PORT=5432/" .env.prod
  set -o allexport && . ./.env.prod && set +o allexport

  docker compose -f compose.yml --project-name $PROJECT_NAME up --detach --pull always

  check_app_status "http://localhost:$MAIN_API_SERVICE_PORT/ping"

  curl http://localhost:$MAIN_API_SERVICE_PORT/helpers/seed
fi

if [ "$rust" == "true" ]; then
  cd ~/backend-comparison/rust-comparison
  cp .env.example .env.prod
  sed -i.bak "s/DEPLOY_ENV=.*/DEPLOY_ENV=prod/" .env.prod
  sed -i.bak "s/PG__HOST=.*/PG__HOST=postgres-db/" .env.prod
  sed -i.bak "s/PG__PORT=.*/PG__PORT=5432/" .env.prod
  set -o allexport && . ./.env.prod && set +o allexport

  docker compose -f compose.yml --project-name $PROJECT_NAME up --detach --pull always

  check_app_status "http://localhost:$MAIN_API_SERVICE_PORT/ping"

  curl http://localhost:$MAIN_API_SERVICE_PORT/helpers/seed
fi