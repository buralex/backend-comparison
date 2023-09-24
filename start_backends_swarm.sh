#!/bin/bash

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

# ============================================
#                  fastify
# ============================================
cd ~/backend-comparison/nodejs-comparison
cp .env.example .env.prod
sed -i.bak "s/DEPLOY_ENV=.*/DEPLOY_ENV=prod/" .env.prod
sed -i.bak "s/POSTGRES_HOST=.*/POSTGRES_HOST=nodejs-comparison-backend_postgres-db/" .env.prod
sed -i.bak "s/POSTGRES_PORT=.*/POSTGRES_PORT=5432/" .env.prod
set -o allexport && . ./.env.prod && set +o allexport

docker stack deploy --compose-file compose.yml $PROJECT_NAME-backend

check_app_status "http://localhost:$MAIN_API_SERVICE_PORT/ping"

curl http://localhost:$MAIN_API_SERVICE_PORT/helpers/seed

# ============================================
#                  gin
# ============================================
# cd ..
cd ~/backend-comparison/go-comparison
cp .env.example .env.prod
sed -i.bak "s/DEPLOY_ENV=.*/DEPLOY_ENV=prod/" .env.prod
sed -i.bak "s/POSTGRES_HOST=.*/POSTGRES_HOST=go-comparison-backend_postgres-db/" .env.prod
sed -i.bak "s/POSTGRES_PORT=.*/POSTGRES_PORT=5432/" .env.prod
set -o allexport && . ./.env.prod && set +o allexport

docker stack deploy --compose-file compose.yml $PROJECT_NAME-backend

check_app_status "http://localhost:$MAIN_API_SERVICE_PORT/ping"

curl http://localhost:$MAIN_API_SERVICE_PORT/helpers/seed