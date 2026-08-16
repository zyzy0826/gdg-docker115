#!/usr/bin/env bash
# 容器啟動：在背景把「社團官網」跑起來（port 8080），然後讓容器保持存活，
# 學生用 `docker compose exec gdg-lab bash` 進來玩。
set -euo pipefail

WEB_DIR="/home/student/club_server/website"
LOG="/home/student/.website_server.log"

if [ -d "$WEB_DIR" ]; then
  cd "$WEB_DIR"
  python3 -m http.server 8080 --bind 0.0.0.0 >"$LOG" 2>&1 &
  echo "[boot] 社團官網已在 http://localhost:8080 啟動（log: $LOG）"
else
  echo "[boot] 找不到 $WEB_DIR，官網沒起來" >&2
fi

cd /home/student
exec "$@"
