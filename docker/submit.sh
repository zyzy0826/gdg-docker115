#!/usr/bin/env bash
# submit — 提交修復碼（flag）
# 用法：submit GDG{...}
#
# 比對方式跟官網 app.js 一樣：djb2 變形雜湊，這裡只存 hash，不存明文。
# 答對會自動寫進 ~/club_server/website/config.json，官網每 3 秒重讀一次。
set -euo pipefail

CONFIG="${GDG_CONFIG:-/home/student/club_server/website/config.json}"

GREEN='\e[1;32m'
RED='\e[1;31m'
YELLOW='\e[1;33m'
CYAN='\e[1;36m'
DIM='\e[2m'
RESET='\e[0m'

if [ $# -eq 0 ]; then
  echo ""
  echo -e "  ${YELLOW}用法${RESET}：submit <你的修復碼>"
  echo -e "  ${YELLOW}範例${RESET}：submit GDG{h3ll0_t3rm1n4l_w0rld}"
  echo ""
  exit 0
fi

if [ $# -gt 1 ]; then
  echo ""
  echo -e "  ${RED}✗ 修復碼裡面不應該有空格${RESET}"
  echo -e "    你輸入的是：$*"
  echo -e "    修復碼是一整串連在一起的字，例如 GDG{h3ll0_t3rm1n4l_w0rld}"
  echo ""
  exit 1
fi

# 所有 JSON 讀寫都交給 python。
# 修復碼用 argv 傳進去（heredoc 加了引號，bash 不會把使用者輸入展開進程式碼）。
# 輸出一行：<結果> <level> <已完成數量>
ERR=$(mktemp)
trap 'rm -f "$ERR"' EXIT

RESULT=$(python3 - "$CONFIG" "$1" 2>"$ERR" <<'PY'
import json
import sys

config_path, flag = sys.argv[1], sys.argv[2].strip()

HASHES = {
    "level0": "ad445dae",
    "level1": "195ab04b",
    "level2": "ad1e2b81",
    "level3": "177bb792",
    "level4": "664a7758",
    "level5": "c67e70cc",
}


def djb2(s):
    x = 5381
    for c in s:
        x = ((x * 33) ^ ord(c)) & 0xFFFFFFFF
    return format(x, "08x")


def solved_count(flags):
    return sum(
        1
        for lv, h in HASHES.items()
        if isinstance(flags.get(lv), str) and djb2(flags[lv].strip()) == h
    )


try:
    with open(config_path, encoding="utf-8") as f:
        data = json.load(f)
except FileNotFoundError:
    print("nofile - 0")
    sys.exit(0)
except ValueError as e:
    print("badjson - 0")
    print(e, file=sys.stderr)
    sys.exit(0)

flags = data.setdefault("flags", {})
matched = next((lv for lv, h in HASHES.items() if djb2(flag) == h), None)

if matched is None:
    print("wrong - %d" % solved_count(flags))
    sys.exit(0)

current = flags.get(matched)
if isinstance(current, str) and djb2(current.strip()) == HASHES[matched]:
    print("dup %s %d" % (matched, solved_count(flags)))
    sys.exit(0)

flags[matched] = flag
with open(config_path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")

print("ok %s %d" % (matched, solved_count(flags)))
PY
) || true

read -r STATE LEVEL SOLVED <<<"${RESULT:-error - 0}"

node_name() {
  case "$1" in
    level0) echo "NODE 0 — 見面禮" ;;
    level1) echo "NODE 1 — cd" ;;
    level2) echo "NODE 2 — 隱藏檔" ;;
    level3) echo "NODE 3 — 解密" ;;
    level4) echo "NODE 4 — tree" ;;
    level5) echo "NODE 5 — 修復專案" ;;
  esac
}

progress_box() {
  local solved=$1 filled empty pct bar="" i
  filled=$(( solved * 4 ))
  empty=$(( 24 - filled ))
  pct=$(( solved * 100 / 6 ))
  for ((i = 0; i < filled; i++)); do bar+="█"; done
  bar="${GREEN}${bar}${RESET}${DIM}"
  for ((i = 0; i < empty; i++)); do bar+="░"; done
  bar+="${RESET}"
  # 右邊不畫框線：中文字在不同 terminal 的寬度不一樣，畫了一定對不齊
  echo -e "  ┌─ 修復進度 ──────────────────────────"
  echo -e "  │  ${bar}  ${solved} / 6  (${pct}%)"
  echo -e "  └─────────────────────────────────────"
}

case "$STATE" in
  wrong)
    echo ""
    echo -e "  ${RED}✗ 修復碼不正確${RESET}"
    echo -e "    確認你有沒有打錯字、漏掉大括號、或多了空格。"
    echo -e "    輸入 ${CYAN}mission${RESET} 查看目前任務提示。"
    echo ""
    exit 1
    ;;
  dup)
    echo ""
    echo -e "  ${YELLOW}△ 你已經提交過 $(node_name "$LEVEL") 了${RESET}"
    echo -e "    輸入 ${CYAN}mission${RESET} 查看下一個任務。"
    echo ""
    ;;
  ok)
    echo ""
    echo -e "  ${GREEN}✓ 修復碼正確！$(node_name "$LEVEL") 已上線${RESET}"
    echo ""
    progress_box "$SOLVED"
    echo ""
    if [ "$SOLVED" -eq 6 ]; then
      echo -e "  ${GREEN}██████████████████████████████████████████████${RESET}"
      echo -e "  ${GREEN}  ALL NODES SECURED — SYSTEM ONLINE${RESET}"
      echo -e "  ${GREEN}██████████████████████████████████████████████${RESET}"
      echo ""
      echo -e "  打開瀏覽器：${CYAN}http://localhost:8080${RESET}"
      echo -e "  官網應該已經復活了。"
      echo ""
    else
      echo -e "  輸入 ${CYAN}mission${RESET} 查看下一個任務。"
      echo ""
    fi
    ;;
  badjson)
    echo ""
    echo -e "  ${RED}✗ config.json 格式壞掉了，沒辦法寫入${RESET}"
    echo -e "    python 說：$(cat "$ERR" 2>/dev/null)"
    echo -e "    用 ${CYAN}nano ~/club_server/website/config.json${RESET} 修好它，"
    echo -e "    通常是少了逗號、引號或大括號。修好之後再 submit 一次。"
    echo ""
    exit 1
    ;;
  nofile)
    echo ""
    echo -e "  ${RED}✗ 找不到官網設定檔：${CONFIG}${RESET}"
    echo -e "    它可能被搬走或刪掉了。重開容器可以還原：docker compose down && docker compose up -d --build"
    echo ""
    exit 1
    ;;
  *)
    echo ""
    echo -e "  ${RED}✗ submit 執行失敗${RESET}"
    cat "$ERR" 2>/dev/null || true
    echo ""
    exit 1
    ;;
esac
