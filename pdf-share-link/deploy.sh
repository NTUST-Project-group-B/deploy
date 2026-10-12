#!/usr/bin/env bash
# 整合測試機用：拉最新的前後端程式碼，並用 Docker Compose 一次啟動
# 用法：cp .env.example .env（填好 POSTGRES_PASSWORD 與兩個 repo 網址）→ ./deploy.sh
set -euo pipefail
cd "$(dirname "$0")"

[ -f .env ] || { echo "找不到 .env，請先 cp .env.example .env 並填寫"; exit 1; }
set -a; . ./.env; set +a

BACKEND_DIR="${BACKEND_DIR:-./backed}"
FRONTEND_DIR="${FRONTEND_DIR:-./fronted}"

sync_repo() {  # sync_repo <目錄> <repo 網址>
  if [ "${SKIP_PULL:-0}" = "1" ]; then return; fi
  if [ -d "$1/.git" ]; then
    git -C "$1" pull --ff-only
  else
    git clone "$2" "$1"
  fi
}

sync_repo "$BACKEND_DIR" "${BACKEND_REPO:?請在 .env 設定 BACKEND_REPO}"
sync_repo "$FRONTEND_DIR" "${FRONTEND_REPO:?請在 .env 設定 FRONTEND_REPO}"

docker compose up --build -d
docker compose ps
echo "完成：http://<這台主機的 IP>:${FRONTEND_PORT:-80}"
