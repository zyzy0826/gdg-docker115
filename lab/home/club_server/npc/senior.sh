#!/usr/bin/env bash
# TypeC（第四屆副社長，現職軟體工程師，很忙但還是會回訊息）
# 用法：./senior.sh      快轉：GDG_FAST=1 ./senior.sh
set -u
cd "$(dirname "$0")"
# shellcheck source=say.sh
. ./say.sh

clear 2>/dev/null || true
blank
sys "正在連線到 TypeC 的訊息通道 ..."
sys "連線成功。（TypeC 在線上，狀態顯示「加班中」）"
blank

say "$C_SENIOR" "TypeC" "喔？這個帳號還會動喔。"
say "$C_SENIOR" "TypeC" "我還以為那台機器早就被拔電源了。"
blank
say "$C_SENIOR" "TypeC" "你是新社員對吧。他有沒有跟你說他做了什麼好事。"
beat
say "$C_SENIOR" "TypeC" "算了，看你能連進來，應該已經被折磨過一輪了。"
blank

wait_key "（按 Enter 繼續對話）"

say "$C_SENIOR" "TypeC" "你要 level3 的密碼對吧。"
say "$C_SENIOR" "TypeC" "我就知道。他每次設完密碼隔天就忘記，四年來沒變過。"
blank
narrate "（訊息輸入中 ...）"
say "$C_SENIOR" "TypeC" "他每次設密碼都用同一個模板：社名 + 他覺得自己很屌。"
say "$C_SENIOR" "TypeC" "大二設 wifi 密碼那次，全社連上去都看得到那串，他還很得意。"
say "$C_SENIOR" "TypeC" "所以是這串，我一個字一個字打給你，不要打錯："
blank

printf "    \e[1;32m┌────────────────────┐\e[0m\n"
printf "    \e[1;32m│  GDGVIP666         │\e[0m\n"
printf "    \e[1;32m└────────────────────┘\e[0m\n"
blank
sleep 1

say "$C_SENIOR" "TypeC" "前面 GDGVIP 六個字母全部大寫，後面是三個 6，沒有底線沒有空格。"
say "$C_SENIOR" "TypeC" "打錯的話 decrypt.py 會噴一堆亂碼，那不是程式壞了，是你手殘。"
blank

wait_key "（按 Enter 繼續對話）"

say "$C_SENIOR" "TypeC" "接下來的步驟我幫你列好："
blank
printf "      1. cd ~/club_server/level3\n"
printf "      2. nano key.txt        ← 建立檔案，把密碼貼進去\n"
printf "      3. Ctrl+O，Enter       ← 存檔（O 是字母，不是零）\n"
printf "      4. Ctrl+X              ← 離開 nano\n"
printf "      5. python3 decrypt.py  ← 解密，拿 flag\n"
blank
sleep 1

say "$C_SENIOR" "TypeC" "檔案裡只放密碼，不要順便打「密碼是：」這種話，程式會讀進去。"
blank
say "$C_SENIOR" "TypeC" "還有，如果你之後在哪個檔案看到他寫「明天一定要刪」——"
say "$C_SENIOR" "TypeC" "他從來沒有明天過。"
blank
say "$C_SENIOR" "TypeC" "好了我要開會了。修好之後記得寄信給我，我想看看官網活過來的樣子。"
blank
narrate "（TypeC 已離線）"
blank
sys "通道關閉。"
blank
