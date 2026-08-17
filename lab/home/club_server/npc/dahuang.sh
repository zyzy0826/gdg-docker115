#!/usr/bin/env bash
# 大黃 —— 第三屆社長，小拿斯的直屬學長，現在在某公司當 SRE。
# 每週三固定登入檢查這台伺服器，四年沒斷過。
# 標準高、脾氣差、但講的每一句都對。第 4 關卡住可以來問他。
# 用法：./dahuang.sh      快轉：GDG_FAST=1 ./dahuang.sh
set -u
cd "$(dirname "$0")"
# shellcheck source=say.sh
. ./say.sh

clear 2>/dev/null || true
blank
sys "偵測到常駐連線：dahuang@gdg-server（第三屆社長，2020-2021，畢業後帳號自己留著）"
sys "每週三 21:00 自動巡檢，已連續 213 週"
sys "對方狀態：線上。上次巡檢報告標題：「又變更亂了」"
blank

say "$C_HUANG" "大黃" "喔，有人在動 level4。"
say "$C_HUANG" "大黃" "終於。我等這一天等了很久。"
blank
say "$C_HUANG" "大黃" "先講清楚，我不會幫你排。"
say "$C_HUANG" "大黃" "我幫你排完，下次還是會亂，因為你沒學會為什麼要那樣排。"
blank
beat
say "$C_HUANG" "大黃" "但我可以告訴你原則。這是我在公司每天在講的東西。"
blank

wait_key "（按 Enter 繼續，大黃還沒罵完）"

printf "  \e[1;38;5;214m┌─ 大黃的整理五條 ────────────────────────────────┐\e[0m\n"
blank
say "$C_HUANG" "大黃" "第一條：一個資料夾只做一件事。"
say "$C_HUANG" "大黃" "設定檔放 config/，素材放 assets/，垃圾放 trash/。"
say "$C_HUANG" "大黃" "東西散在專案根目錄，代表你根本沒決定它是什麼。"
blank
say "$C_HUANG" "大黃" "第二條：搞清楚 mv 跟 cp 的差別。"
say "$C_HUANG" "大黃" "mv 是搬，東西會離開原地；cp 是複製，原地那份還在。"
say "$C_HUANG" "大黃" "該 mv 的用 cp，你就會有兩份不一樣的真相，"
say "$C_HUANG" "大黃" "然後半年後有人改到錯的那份。我看過三次。"
blank
say "$C_HUANG" "大黃" "第三條：動手前 ls -R 看一次，動手後 ls -R 再看一次。"
say "$C_HUANG" "大黃" "不要用「我記得我搬過去了」當作證據。"
blank
say "$C_HUANG" "大黃" "第四條：檔名要能讓半年後的你看懂。"
beat
say "$C_HUANG" "大黃" "level5 裡面有個資料夾叫 final_v3_FINAL。"
say "$C_HUANG" "大黃" "那是小拿斯取的。我看到的時候血壓直接上去。"
blank
say "$C_HUANG" "大黃" "第五條：rm 之前深呼吸三秒。"
say "$C_HUANG" "大黃" "備份不是「還在某個地方」，備份是「你現在就能指出它在哪」。"
blank
printf "  \e[1;38;5;214m└─────────────────────────────────────────────────┘\e[0m\n"
blank

wait_key "（按 Enter 繼續）"

say "$C_HUANG" "大黃" "好，看在你願意進來收爛攤子的份上，給你一點方向。"
say "$C_HUANG" "大黃" "不是答案，是方向。"
blank
say "$C_HUANG" "大黃" "第一，那個專案缺的資料夾根本不存在，不是被藏起來。"
say "$C_HUANG" "大黃" "不存在的東西要自己建。指令是 mkdir。"
blank
say "$C_HUANG" "大黃" "第二，設定檔應該「離開」根目錄，備份應該「留在」原地。"
say "$C_HUANG" "大黃" "一個用 mv，一個用 cp。哪個配哪個，你自己想。"
blank
say "$C_HUANG" "大黃" "第三，main.py 每一行 [FAIL] 都寫了該打什麼指令。"
say "$C_HUANG" "大黃" "看不懂錯誤訊息就想放棄，是這一行最貴的壞習慣。"
blank
sleep 1

say "$C_HUANG" "大黃" "還有一件事，跟解謎無關。"
beat
say "$C_HUANG" "大黃" "我對小拿斯很不爽，這你應該看得出來。"
say "$C_HUANG" "大黃" "把伺服器搞成這樣就跑掉，這叫不負責任，沒什麼好浪漫化的。"
blank
say "$C_HUANG" "大黃" "但我每週三還是會登入，看看有沒有人回來。"
say "$C_HUANG" "大黃" "他畢業之後，這台機器爛了一年，社團也空了一年。"
say "$C_HUANG" "大黃" "第五屆，你是第一個回來的。"
beat
say "$C_HUANG" "大黃" "……排乾淨一點。拜託。"
blank
say "$C_HUANG" "大黃" "喔對，如果你在走廊上看到一個一直嘻嘻笑的傢伙，不用理他。"
say "$C_HUANG" "大黃" "他叫西西。我到現在還不確定他到底會不會寫 code。"
say "$C_HUANG" "大黃" "腳本在 npc/sisi.sh，你要浪費時間我不管。"
blank
narrate "（大黃把巡檢報告存檔了，檔名是 2025-report_v2_修正版_最終.md）"
narrate "（……他自己好像沒發現。）"
blank
sys "連線保持中。大黃不會離線，他只是不講話。"
blank
