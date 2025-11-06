#!/usr/bin/env bash
set -euo pipefail
# Usage: ./build.sh <dockerhub_user> <repo> <tag>
DOCKER_USER=${1:-yourdockeruser}
REPO=${2:-dev}
TAG=${3:-latest}
IMAGE="$DOCKER_USER/$REPO:$TAG"
echo "Building image $IMAGE"
# Build using local Dockerfile
docker build -t "$IMAGE" .
echo "Pushing image to Docker Hub"
docker push "$IMAGE"
