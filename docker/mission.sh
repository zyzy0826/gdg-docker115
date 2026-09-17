#!/usr/bin/env bash
# mission — 查看任務狀態與目前該做什麼
# 進度是即時從 ~/club_server/website/config.json 算出來的，
# 所以不管是用 submit 交的還是自己 nano 填的，這裡都看得到。
set -euo pipefail

CONFIG="${GDG_CONFIG:-/home/student/club_server/website/config.json}"

GREEN='\e[1;32m'
RED='\e[1;31m'
YELLOW='\e[1;33m'
CYAN='\e[1;36m'
DIM='\e[2m'
RESET='\e[0m'

# 輸出六個 0/1，用逗號隔開；config.json 壞掉就輸出 BAD
STATUS=$(python3 - "$CONFIG" <<'PY'
import json
import sys

HASHES = ["ad445dae", "195ab04b", "ad1e2b81", "177bb792", "664a7758", "c67e70cc"]


def djb2(s):
    x = 5381
    for c in s:
        x = ((x * 33) ^ ord(c)) & 0xFFFFFFFF
    return format(x, "08x")


try:
    with open(sys.argv[1], encoding="utf-8") as f:
        flags = json.load(f).get("flags", {})
except (OSError, ValueError, AttributeError):
    print("BAD")
    sys.exit(0)

out = []
for i, h in enumerate(HASHES):
    val = flags.get("level%d" % i)
    out.append("1" if isinstance(val, str) and djb2(val.strip()) == h else "0")
print(",".join(out))
PY
) || STATUS="BAD"

if [ "$STATUS" = "BAD" ]; then
  echo ""
  echo -e "  ${RED}✗ 讀不到任務進度：config.json 不見了或格式壞掉${RESET}"
  echo -e "    用 ${CYAN}nano ~/club_server/website/config.json${RESET} 檢查一下，"
  echo -e "    或打開 ${CYAN}http://localhost:8080${RESET}，網頁會告訴你哪裡壞了。"
  echo ""
  exit 1
fi

IFS=',' read -ra DONE <<<"$STATUS"

LABELS=(
  "NODE 0 — cat（讀取檔案）"
  "NODE 1 — cd（切換目錄）"
  "NODE 2 — ls -a（隱藏檔）"
  "NODE 3 — nano + python3（解密）"
  "NODE 4 — apt install tree（搜尋）"
  "NODE 5 — mkdir / mv / cp（修復專案）"
)

# 每關的提示（多行，印的時候會自動縮排）
HINTS=(
"輸入 cat ~/hint.txt，裡面有第一個修復碼。
拿到之後：submit GDG{...}"

"cd ~/club_server/level1/backup/old_stuff/
然後 cat flag.txt 讀取修復碼。
迷路了就 pwd 看自己在哪，cd ~ 回家。"

"cd ~/club_server/level2
輸入 ls 看起來沒什麼，但試試 ls -a。
有些東西開頭加了一個「.」，ls 預設看不到。"

"先去問 typec-mini 拿密碼：
    bash ~/club_server/npc/senior.sh
拿到密碼後：
    cd ~/club_server/level3
    nano key.txt   （把密碼打進去，Ctrl+O 存檔，Ctrl+X 離開）
    python3 decrypt.py"

"這關要先裝一個工具：
    sudo apt install tree
然後：
    cd ~/club_server/level4
    tree -a | grep flag
提示：最深處的資料夾名稱開頭有「.」"

"先讀 cat ~/club_server/level5/note.txt 了解狀況。
然後 cd ~/club_server/level5/broken_project
把散亂的檔案排回正確位置，再跑 python3 main.py。
可以用 tree 確認結構排對了沒。"
)

SOLVED=0
CURRENT=-1

echo ""
echo -e "  ┌─ GDG-SERVER // 任務狀態 ────────────────────"
echo -e "  │"
for i in 0 1 2 3 4 5; do
  if [ "${DONE[$i]}" = "1" ]; then
    echo -e "  │  ${GREEN}[✓]${RESET} ${LABELS[$i]}"
    SOLVED=$((SOLVED + 1))
  else
    echo -e "  │  ${DIM}[ ]${RESET} ${LABELS[$i]}"
    if [ "$CURRENT" -eq -1 ]; then
      CURRENT=$i
    fi
  fi
done
echo -e "  │"
echo -e "  │  已上線：${SOLVED} / 6"
echo -e "  └─────────────────────────────────────────────"
echo ""

if [ "$SOLVED" -eq 6 ]; then
  echo -e "  ${GREEN}所有安全節點已修復！${RESET}"
  echo ""
  echo -e "  打開瀏覽器看看官網：${CYAN}http://localhost:8080${RESET}"
  echo ""
  echo -e "  ${DIM}（bonus：輸入 nano ~/club_server/website/config.json"
  echo -e "   看看你剛才 submit 的修復碼是怎麼存進 JSON 的）${RESET}"
  echo ""
else
  echo -e "  ${YELLOW}► 目前任務：${LABELS[$CURRENT]}${RESET}"
  echo ""
  # 用 printf 而不是 echo -e，提示裡的反斜線才不會被吃掉
  while IFS= read -r line; do
    printf '    %s\n' "$line"
  done <<<"${HINTS[$CURRENT]}"
  echo ""
  echo -e "  ${DIM}找到修復碼後輸入：submit GDG{...}${RESET}"
  echo ""
fi
