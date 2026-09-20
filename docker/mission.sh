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
  "LEVEL 0 — 讀取檔案"
  "LEVEL 1 — 在資料夾之間移動"
  "LEVEL 2 — 找出隱藏檔"
  "LEVEL 3 — 編輯檔案與解密"
  "LEVEL 4 — 安裝工具與深層搜尋"
  "LEVEL 5 — 整理專案結構"
)

# 每關的提示：只用白話描述「要做什麼」，不直接給可以複製貼上的指令。
# 指令怎麼打由社課的操作手冊負責，這裡是讓學生自己想該用哪個指令。
HINTS=(
"家目錄裡有一張小拿斯留下的便條紙，檔名是 hint.txt。
把它的內容印出來讀一讀，第一個 flag 就在裡面。"

"小拿斯把這個 flag 藏在 club_server 資料夾的 level1 裡面，
要往下走好幾層資料夾才找得到。
每走進一層，先看看這裡有哪些東西，再決定下一步往哪走。
找到 flag 檔案之後，把它的內容印出來。
迷路的時候，先確認自己現在在哪裡，或直接回家目錄重來。"

"走進 level2 資料夾，列出裡面的檔案。
看起來好像沒什麼特別的，但檔名開頭是「.」的檔案，
一般列出檔案時不會顯示。想辦法讓隱藏的檔案現形，
再把可疑的那個檔案印出來。"

"level3 裡的 flag 被加密了，解密程式需要一個叫 key.txt 的密碼檔，
但小拿斯把密碼忘了。先讀 level3 裡的便條紙了解狀況。
密碼要去問 TypeC 的分身 typec-mini，它的腳本在 npc 資料夾裡。
拿到密碼後，回到 level3 用文字編輯器建立 key.txt，把密碼存進去，
最後執行解密程式。"

"level4 是一個有幾百個資料夾的照片檔案庫，一層一層翻會翻到天亮。
先讀 level4 裡的便條紙，然後用管理員權限安裝一個
能把整個目錄畫成樹狀圖的工具。
用它把檔案庫攤開來找 flag 檔案，記得連隱藏的資料夾也要顯示，
而且要看得出檔案的完整路徑。小心，裡面有假的。"

"level5 的專案被小拿斯拆亂了，程式找不到它要的檔案。
先讀 level5 裡的便條紙，搞清楚專案原本應該長什麼樣子。
缺少的資料夾要自己建立；該搬走的檔案用搬的，
該留著當備份的檔案用複製的，兩種不要搞混。
排好之後執行專案裡的程式，它會告訴你哪裡還不對。
上一關裝的工具可以幫你確認結構有沒有排對。"
)

SOLVED=0
CURRENT=-1

echo ""
echo -e "  ┌─ gdg-server // 任務進度 ────────────────────"
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
echo -e "  │  已取得：${SOLVED} / 6 flag"
echo -e "  └─────────────────────────────────────────────"
echo ""

if [ "$SOLVED" -eq 6 ]; then
  echo -e "  ${GREEN}六個 flag 全部到手！${RESET}"
  echo ""
  echo -e "  打開瀏覽器看看官網：${CYAN}http://localhost:8080${RESET}"
  echo ""
  echo -e "  ${DIM}（bonus：用文字編輯器打開 website 資料夾裡的 config.json，"
  echo -e "   看看你剛才 submit 的 flag 是怎麼存進 JSON 的）${RESET}"
  echo ""
else
  echo -e "  ${YELLOW}► 目前任務：${LABELS[$CURRENT]}${RESET}"
  echo ""
  # 用 printf 而不是 echo -e，提示裡的反斜線才不會被吃掉
  while IFS= read -r line; do
    printf '    %s\n' "$line"
  done <<<"${HINTS[$CURRENT]}"
  echo ""
  echo -e "  ${DIM}找到 flag 後輸入：submit GDG{...}${RESET}"
  echo ""
fi
