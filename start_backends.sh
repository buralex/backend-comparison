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
cd ~/backend-comparison/fastify-comparison
cp .env.example .env.prod
sed -i.bak "s/DEPLOY_ENV=.*/DEPLOY_ENV=prod/" .env.prod
sed -i.bak "s/POSTGRES_HOST=.*/POSTGRES_HOST=postgres-db/" .env.prod
sed -i.bak "s/POSTGRES_PORT=.*/POSTGRES_PORT=5432/" .env.prod
set -o allexport && . ./.env.prod && set +o allexport

docker compose -f compose.yml --project-name $PROJECT_NAME up --detach --pull always

check_app_status "http://localhost:$MAIN_API_SERVICE_PORT/ping"

curl http://localhost:$MAIN_API_SERVICE_PORT/helpers/seed



# ============================================
#                  gin
# ============================================
# cd ..
cd ~/backend-comparison/gin-comparison
cp .env.example .env.prod
sed -i.bak "s/DEPLOY_ENV=.*/DEPLOY_ENV=prod/" .env.prod
sed -i.bak "s/POSTGRES_HOST=.*/POSTGRES_HOST=postgres-db/" .env.prod
sed -i.bak "s/POSTGRES_PORT=.*/POSTGRES_PORT=5432/" .env.prod
set -o allexport && . ./.env.prod && set +o allexport

docker compose -f compose.yml --project-name $PROJECT_NAME up --detach --pull always

check_app_status "http://localhost:$MAIN_API_SERVICE_PORT/ping"

curl http://localhost:$MAIN_API_SERVICE_PORT/helpers/seed