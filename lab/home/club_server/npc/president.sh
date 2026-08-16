#!/usr/bin/env bash
# 小拿斯留下的「語音留言」（其實就是一堆 echo）
# 用法：./president.sh    快轉：GDG_FAST=1 ./president.sh
set -u
cd "$(dirname "$0")"
# shellcheck source=say.sh
. ./say.sh

clear 2>/dev/null || true
blank
sys "找到一個未播放的錄音檔：ex_president_final.wav"
sys "錄製時間：2024-06-14 04:07"
sys "播放中 ..."
blank
narrate "（一陣電流雜訊，背景有冷氣壞掉的聲音）"
blank

say "$C_PRES" "小拿斯" "喂？有在錄嗎。喔，紅燈亮了，有在錄。"
say "$C_PRES" "小拿斯" "咳。嗨，未來的社員。"
blank
say "$C_PRES" "小拿斯" "如果你聽到這段，代表你已經找到 npc 資料夾了，不錯嘛。"
say "$C_PRES" "小拿斯" "我現在人在社辦，剛畢業，穿著學士服，有點想哭但主要是因為冷氣壞了。"
blank

wait_key "（按 Enter 繼續播放）"

say "$C_PRES" "小拿斯" "我知道你在罵我。把伺服器搞成這樣很沒品，我承認。"
beat
say "$C_PRES" "小拿斯" "但我跟你講一件事。"
say "$C_PRES" "小拿斯" "我大一進社團的時候，看到黑色畫面就手心冒汗，"
say "$C_PRES" "小拿斯" "連 ls 都要偷偷 google，怕被學長笑。"
blank
say "$C_PRES" "小拿斯" "後來有一天伺服器掛了，只剩我在社辦。"
say "$C_PRES" "小拿斯" "我一個資料夾一個資料夾翻，翻到凌晨三點，最後把它修好了。"
say "$C_PRES" "小拿斯" "那天之後，黑色畫面對我來說就只是個工具而已。"
blank
say "$C_PRES" "小拿斯" "沒有人是看教學影片變強的。是被逼到牆角然後亂翻，才會變強。"
blank

wait_key "（按 Enter 繼續播放）"

say "$C_PRES" "小拿斯" "所以我把東西打散了。六個 flag，六種你以後每天都會用到的招式。"
say "$C_PRES" "小拿斯" "cd、ls -a、nano、mkdir、mv、cp、apt install。"
say "$C_PRES" "小拿斯" "都很基本，基本到沒有人願意花時間教。"
blank
say "$C_PRES" "小拿斯" "全部找齊之後，填進 website/config.json，官網就會回來。"
say "$C_PRES" "小拿斯" "那個官網是我大二寫的，很醜，但那是我第一個上線的東西。"
blank
say "$C_PRES" "小拿斯" "拜託你們幫我維持著，不然它就真的消失了。"
beat
say "$C_PRES" "小拿斯" "喔對，冰箱那罐可樂真的不是我的，不要再問我了。"
blank
narrate "（有人在遠處喊「欸社長拍照了」）"
say "$C_PRES" "小拿斯" "啊，要拍照了。掰掰。祝你好運。"
blank
narrate "（錄音結束）"
blank
sys "播放完畢。這段錄音裡沒有 flag，但你大概已經知道了。"
blank
