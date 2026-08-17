#!/usr/bin/env bash
# typec-mini —— TypeC（第四屆副社長，現在在做 AI 研究）留下的分身模型。
# 本體太忙，所以他把自己 fine-tune 成一個 model 丟在社團伺服器上，
# 社員半夜卡住可以隨時問，不用敲本人。
# 用法：./senior.sh      快轉：GDG_FAST=1 ./senior.sh
set -u
cd "$(dirname "$0")"
# shellcheck source=say.sh
. ./say.sh

clear 2>/dev/null || true
blank
sys "正在載入 typec-mini ..."
sys "權重檔：/opt/typec-mini/weights.gguf（1.7 GB，就跑在這台機器上，沒連外網）"
sys "訓練資料：社團四年份的聊天紀錄、社課投影片、還有 312 則抱怨小拿斯的訊息"
sys "最後一次同步：2024-06-12 23:41"
sys "載入完成。提醒：這是 TypeC 訓練的分身模型，不是本人。"
blank

say "$C_SENIOR" "typec-mini" "嗨。我是 TypeC 的分身。"
say "$C_SENIOR" "typec-mini" "本體在做 AI 研究，忙到訊息都用已讀當回覆，"
say "$C_SENIOR" "typec-mini" "所以他乾脆訓練了一個自己的 model 丟在這台機器上。"
blank
say "$C_SENIOR" "typec-mini" "他的原話是：「這樣你們半夜卡住就不用敲我了。」"
say "$C_SENIOR" "typec-mini" "我知道的事情跟他差不多，差別是我不會生氣。（本體會。）"
blank

wait_key "（按 Enter 繼續對話）"

say "$C_SENIOR" "typec-mini" "展開說說。"
say "$C_SENIOR" "typec-mini" "你要 level3 的密碼對吧。"
say "$C_SENIOR" "typec-mini" "查一下訓練資料……這個問題出現過 27 次。"
beat
say "$C_SENIOR" "typec-mini" "其中 26 次是小拿斯自己來問的，他忘記自己設了什麼。"
blank
narrate "（正在生成 ...）"
say "$C_SENIOR" "typec-mini" "他設密碼一輩子只用一個模板：社名 + 他覺得自己很屌。"
say "$C_SENIOR" "typec-mini" "大二那次 wifi 密碼也是這樣設的，全社連上去都看得到，他還很得意。"
blank
say "$C_SENIOR" "typec-mini" "所以是這串，我一個字一個字輸出給你，不要打錯："
blank

printf "    \e[1;32m┌────────────────────┐\e[0m\n"
printf "    \e[1;32m│  GDGVIP666         │\e[0m\n"
printf "    \e[1;32m└────────────────────┘\e[0m\n"
blank
sleep 1

say "$C_SENIOR" "typec-mini" "前面 GDGVIP 六個字母全部大寫，後面是三個 6，沒有底線沒有空格。"
say "$C_SENIOR" "typec-mini" "打錯的話 decrypt.py 會噴一堆亂碼，那不是程式壞了，是你手殘。"
blank

wait_key "（按 Enter 繼續對話）"

say "$C_SENIOR" "typec-mini" "接下來的步驟我幫你列好："
blank
printf "      1. cd ~/club_server/level3\n"
printf "      2. nano key.txt        ← 建立檔案，把密碼貼進去\n"
printf "      3. Ctrl+O，Enter       ← 存檔（O 是字母，不是零）\n"
printf "      4. Ctrl+X              ← 離開 nano\n"
printf "      5. python3 decrypt.py  ← 解密，拿 flag\n"
blank
sleep 1

say "$C_SENIOR" "typec-mini" "檔案裡只放密碼，不要順便打「密碼是：」這種話，程式會讀進去。"
blank
say "$C_SENIOR" "typec-mini" "還有一件事，本體要我每次都講："
say "$C_SENIOR" "typec-mini" "我是模型，我會產生幻覺。上面這幾行指令我很確定，"
say "$C_SENIOR" "typec-mini" "但如果我開始跟你講 2027 年的社遊有多好玩，那是我掰的，不要信。"
blank
say "$C_SENIOR" "typec-mini" "本體還留了一句話要我轉達給修好伺服器的人："
say "$C_SENIOR" "typec-mini" "「弄好之後寄信給我，我想看看官網活過來的樣子。」"
blank
say "$C_SENIOR" "typec-mini" "他打完那句就下線了，那是我最後一次同步到他。"
blank
narrate "（typec-mini 已卸載，釋放 1.7 GB 記憶體）"
blank
sys "通道關閉。想再問一次就再執行一次這個腳本，我不會累。"
blank
