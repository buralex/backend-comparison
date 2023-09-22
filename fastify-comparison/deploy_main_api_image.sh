#!/bin/bash

[ -z "$PROJECT_NAME" ] && echo "Empty PROJECT_NAME" && exit 1
[ -z "$DEPLOY_ENV" ] && echo "Empty DEPLOY_ENV" && exit 1

MAIN_API_IMAGE_NAME=buralex/public:$PROJECT_NAME-main-api

echo "image name: $MAIN_API_IMAGE_NAME"

docker build -t $MAIN_API_IMAGE_NAME .
docker push $MAIN_API_IMAGE_NAME

if [ $? -eq 0 ]; then
    echo "Docker build and push command executed successfully."
else
    echo "Error: Docker build and push command failed."
    exit 1
fi