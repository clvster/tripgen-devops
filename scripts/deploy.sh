#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COMPOSE_FILE="$REPO_DIR/docker-compose.yml"

echo "=== TripGen Deploy ==="
echo "Directory: $REPO_DIR"

cd "$REPO_DIR"

echo "--> git pull..."
git pull origin main
git submodule update --init --remote --recursive

if [[ ! -f .env ]]; then
  echo "ERROR: .env not found. Copy .env.example and fill in real values."
  exit 1
fi

BUILD_FLAG=""
if [[ "${1:-}" == "--build" ]]; then
  BUILD_FLAG="--build"
  echo "--> Building images..."
fi

echo "--> Starting containers..."
docker compose -f "$COMPOSE_FILE" up -d --remove-orphans $BUILD_FLAG

echo "--> Cleanup..."
docker image prune -f

echo "--> Status:"
docker compose -f "$COMPOSE_FILE" ps

echo "=== Done ==="

