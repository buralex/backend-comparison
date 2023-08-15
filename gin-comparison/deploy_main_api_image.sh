#!/bin/bash

[ -z "$PROJECT_NAME" ] && echo "Empty PROJECT_NAME" && exit 1
[ -z "$DEPLOY_ENV" ] && echo "Empty DEPLOY_ENV" && exit 1

MAIN_API_IMAGE_NAME=buralex/public:$PROJECT_NAME-$DEPLOY_ENV-backend-main-api

echo "image name: $MAIN_API_IMAGE_NAME"

# try/catch https://stackoverflow.com/a/25554904/8083104
set +e
bash -e <<EOF
  docker build -t $MAIN_API_IMAGE_NAME .
  docker push $MAIN_API_IMAGE_NAME
EOF
errorCode=$?
if [ $errorCode -ne 0 ]; then
  echo "We have an error $errorCode"
  exit $errorCode
fi