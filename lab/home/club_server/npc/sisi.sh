#!/usr/bin/env bash
# 西西 —— 社團成員。入社四年，出席率 100%，發言紀錄全部都是「嘻嘻」。
# 沒有人知道他負責什麼，但每次社課他都在。
# 這支腳本不會給你任何提示。真的。
# 用法：./sisi.sh      快轉：GDG_FAST=1 ./sisi.sh
set -u
cd "$(dirname "$0")"
# shellcheck source=say.sh
. ./say.sh

clear 2>/dev/null || true
blank
sys "正在連線到 西西 ..."
sys "連線成功。"
blank

say "$C_SISI" "西西" "嘻嘻。"
blank
say "$C_SISI" "西西" "嘻嘻嘻。"
blank
narrate "（你等了一下，感覺他好像還要說什麼。）"
blank
say "$C_SISI" "西西" "嘻。"
blank

wait_key "（按 Enter 繼續……如果你真的想繼續的話）"

sys "偵測到溝通障礙，正在啟動語意翻譯模組（beta）..."
sleep 1
sys "分析中 ..."
sleep 1
sys "翻譯完成。"
blank
printf "    \e[1;38;5;213m┌────────────────────┐\e[0m\n"
printf "    \e[1;38;5;213m│  翻譯結果：嘻嘻    │\e[0m\n"
printf "    \e[1;38;5;213m└────────────────────┘\e[0m\n"
blank
sys "翻譯模組已自行卸載。它說它不想再試一次。"
blank

say "$C_SISI" "西西" "嘻嘻嘻嘻。"
blank
narrate "（他點了點頭，好像很滿意。）"
blank
say "$C_SISI" "西西" "其實 flag 在——"
beat
say "$C_SISI" "西西" "嘻嘻。"
blank
narrate "（他笑得很開心。你什麼都沒得到。）"
blank

wait_key "（按 Enter 離開）"

printf "         \e[1;38;5;213m(ﾉ◕ヮ◕)ﾉ ﾟ・･ﾟ  嘻嘻\e[0m\n"
blank
sys "對話結束。本次對話提供的有效資訊量：0 bytes。"
sys "（大黃有警告過你。）"
blank
