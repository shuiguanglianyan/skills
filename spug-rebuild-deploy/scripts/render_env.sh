#!/usr/bin/env bash
set -euo pipefail

OUT_FILE="${1:-.env}"

rand() {
  tr -dc 'A-Za-z0-9' </dev/urandom | head -c 24
}

cat > "$OUT_FILE" <<ENV
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-$(rand)}
MYSQL_DATABASE=${MYSQL_DATABASE:-spug}
MYSQL_USER=${MYSQL_USER:-spug}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-$(rand)}
REDIS_PASSWORD=${REDIS_PASSWORD:-$(rand)}
APP_SECRET_KEY=${APP_SECRET_KEY:-$(rand)}
ADMIN_USERNAME=${ADMIN_USERNAME:-admin}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-$(rand)}
WEB_PORT=${WEB_PORT:-80}
SPUG_BACKEND_IMAGE=${SPUG_BACKEND_IMAGE:-ghcr.io/shuiguanglianyan/spug-rebuild-backend:latest}
SPUG_FRONTEND_IMAGE=${SPUG_FRONTEND_IMAGE:-ghcr.io/shuiguanglianyan/spug-rebuild-frontend:latest}
ENV

echo "[OK] wrote $OUT_FILE"
echo "[INFO] next: docker compose --env-file $OUT_FILE -f docker-compose.yml up -d"
