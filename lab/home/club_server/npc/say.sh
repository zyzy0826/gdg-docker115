#!/usr/bin/env bash
# 共用的對話函式庫。被 president.sh / senior.sh source 進去。
# 想快轉的話：GDG_FAST=1 ./senior.sh

GDG_DELAY="${GDG_DELAY:-0.9}"
if [ "${GDG_FAST:-0}" = "1" ]; then
  GDG_DELAY=0
fi

C_RESET='\e[0m'
C_PRES='\e[1;36m'    # 小拿斯：青色
C_SENIOR='\e[1;35m'  # TypeC / typec-mini：紫色
C_SYS='\e[1;33m'     # 系統：黃色
C_DIM='\e[2m'

# say <說話者顏色> <名字> <台詞>
say() {
  printf "${1}%s${C_RESET}：%s\n" "$2" "$3"
  sleep "$GDG_DELAY"
}

# narrate <旁白>  — 灰色斜體感，用來寫場景
narrate() {
  printf "${C_DIM}%s${C_RESET}\n" "$1"
  sleep "$GDG_DELAY"
}

# sys <系統訊息>
sys() {
  printf "${C_SYS}[系統]${C_RESET} %s\n" "$1"
  sleep "$GDG_DELAY"
}

blank() {
  printf "\n"
  sleep "$(awk -v d="$GDG_DELAY" 'BEGIN{print d/2}')"
}

# beat — 停頓一下，製造尷尬的沉默
beat() {
  sleep "$GDG_DELAY"
  sleep "$GDG_DELAY"
}

# wait_key <提示文字>
wait_key() {
  if [ "${GDG_FAST:-0}" = "1" ]; then
    return
  fi
  printf "${C_DIM}%s${C_RESET}" "${1:-（按 Enter 繼續）}"
  read -r _ </dev/tty || true
  printf "\n"
}
