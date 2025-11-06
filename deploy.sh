#!/usr/bin/env bash
set -euo pipefail
DOCKER_USER=${1:-yourdockeruser}
REPO=${2:-dev}
TAG=${3:-latest}
IMAGE="$DOCKER_USER/$REPO:$TAG"

# If using docker-compose, pull and recreate
if [ -f docker-compose.yml ]; then
  echo "Pulling image $IMAGE"
  docker-compose pull || true
  docker-compose up -d --remove-orphans
else
  # fallback to docker run
  echo "Stopping old container (if any)"
  docker ps -q --filter "name=webapp" | xargs -r docker stop
  docker ps -a -q --filter "name=webapp" | xargs -r docker rm
  echo "Running new container"
  docker run -d --name webapp -p 80:80 --restart=always "$IMAGE"
fi

echo "Deploy complete"
