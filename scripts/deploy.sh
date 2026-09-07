#!/bin/bash
set -e

IMAGE_NAME=$1
CONTAINER_NAME="devops-web-contaner"

echo "Deploying image: $IMAGE_NAME"

docker stop "$CONTAINER_NAME" || true
docker rm "$CONTAINER_NAME" || true

docker run -d \
  --name "$CONTAINER_NAME" \
  -p 80:80 \
  "$IMAGE_NAME"

sleep 5

docker ps \
  --filter "name=^/${CONTAINER_NAME}$" \
  --filter "status=running" \
  --format '{{.Names}}' | grep -Fx "$CONTAINER_NAME"

curl --fail http://localhost/

echo "Deployment successful"