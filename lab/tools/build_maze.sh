#!/usr/bin/env bash
# 在 build image 的時候產生第 4 關的「照片檔案庫」迷宮。
# 用法：bash build_maze.sh /home/student/club_server/level4
set -euo pipefail

TARGET="${1:?用法: build_maze.sh <level4 目錄>}"
ARCHIVE="$TARGET/archive"

mkdir -p "$ARCHIVE"

YEARS="2016 2017 2018 2019 2020 2021 2022 2023"
SEASONS="spring summer fall winter"
KINDS="photos slides receipts code"

for y in $YEARS; do
  for s in $SEASONS; do
    for k in $KINDS; do
      d="$ARCHIVE/$y/$s/$k"
      mkdir -p "$d"
    done
    # 隨便塞一點雜物，讓它看起來像真的檔案庫
    printf '（空的。小拿斯說「這裡本來有東西」。）\n' > "$ARCHIVE/$y/$s/photos/README.txt"
    printf 'session %s %s: 投影片檔案已遺失\n' "$y" "$s" > "$ARCHIVE/$y/$s/slides/index.txt"
    printf '披薩,-%d\n' "$(( (RANDOM % 9 + 1) * 100 ))" > "$ARCHIVE/$y/$s/receipts/pizza.csv"
  done
done

# ---- 幾個假的「看起來很可疑」的路徑，故意騙人 ----
mkdir -p "$ARCHIVE/2020/winter/code/secret"
cat > "$ARCHIVE/2020/winter/code/secret/flag.txt" <<'EOF'
GDG{n1c3_try_but_n0t_th1s_0n3}

哈，假的。

真的那個藏得更深，而且我用了一點小手段：
資料夾名稱開頭加了一個「.」，所以 tree 預設看不到它。
（跟第 2 關的隱藏檔是同一招，我沒有創意。）

tree -a 才會顯示隱藏的東西。去吧。

                                        -- 小拿斯
EOF

mkdir -p "$ARCHIVE/2017/fall/photos/important"
cat > "$ARCHIVE/2017/fall/photos/important/DO_NOT_OPEN.txt" <<'EOF'
你打開了。

裡面沒有 flag，只有一張 2017 年社遊的照片描述：
「八個人擠在一台休旅車裡，社長在開車，副社長在哭。」

                                        -- 小拿斯
EOF

# ---- 真正的 flag ----
REAL="$ARCHIVE/2022/summer/photos/raw/hackathon_0713/.cache/thumbs/backup/final_v3_FINAL"
mkdir -p "$REAL"
cat > "$REAL/flag.txt" <<'EOF'
================================================================
  LEVEL 4 CLEAR — 你把整棵樹翻完了
================================================================

    GDG{tr33_s33s_3v3ryth1ng}

交出來：submit GDG{tr33_s33s_3v3ryth1ng}

順帶一提，資料夾叫 final_v3_FINAL 是因為我大二做專題時
存過 final、final_v2、final_真的最後一版、final_v3_FINAL。
你以後也會這樣，不要嘴我。

----------------------------------------------------------------
[LEVEL 5] 最後一關：被我拆爛的專案

最後一個 flag 在：
    ~/club_server/level5

那裡放的是官網的「橫幅產生器」子專案。
那天晚上我覺得它的資料夾結構「很不整齊」，就手賤重新整理了一下。
然後就壞了。

你要用 mkdir / mv / cp 把檔案排回它該在的位置，
程式會自己檢查，排對了它就把 flag 吐給你。
剛裝的 tree 這時候會很好用。

詳細說明看：cat ~/club_server/level5/note.txt

                                        -- 小拿斯
EOF

# 藏在同一層的彩蛋
cat > "$REAL/hackathon_2022.txt" <<'EOF'
2022 夏季黑客松 · 照片說明（只剩文字，照片檔在那顆燒掉的硬碟裡）

  IMG_0713_001  開幕，全社十二個人，五個人在睡覺
  IMG_0713_047  TypeC 在白板上畫架構圖，畫到第四張
  IMG_0713_112  小拿斯對著紅色的 error 訊息笑得很開心（那是他第一次自己 debug 成功）
  IMG_0713_188  凌晨四點，桌上八個披薩盒，程式終於跑起來
  IMG_0713_190  日出。大家在頂樓。沒有人記得那天做出了什麼專案，
                但每個人都記得那個日出。

  這就是為什麼我把伺服器留給你們，而不是關掉它。
EOF
