#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
官網橫幅產生器 v0.3（小拿斯作品，2022）

它只做一件事：讀設定檔 + 讀社徽，然後把橫幅印出來。
但它很固執，檔案不在正確的位置就罷工。

    python3 main.py
"""

import configparser
import os
import sys

ROOT = os.path.dirname(os.path.abspath(__file__))

CONFIG = os.path.join(ROOT, "config", "settings.ini")
STRAY_CONFIG = os.path.join(ROOT, "settings.ini")
LOGO = os.path.join(ROOT, "assets", "logo.txt")
BACKUP_LOGO = os.path.join(ROOT, "trash", "logo.txt")

FLAG = "GDG{pr0j3ct_r3st0r3d_g00d_j0b}"
LINE = "=" * 64


def check(ok, ok_msg, bad_msg, fix):
    """回傳 (通過?, 顯示用的字串, 修法)"""
    mark = "\033[1;32m[ OK ]\033[0m" if ok else "\033[1;31m[FAIL]\033[0m"
    print("  %s %s" % (mark, ok_msg if ok else bad_msg))
    return (ok, fix)


def main():
    print()
    print(LINE)
    print("  官網橫幅產生器 · 啟動自我檢查")
    print(LINE)

    results = [
        check(
            os.path.isfile(CONFIG),
            "找到 config/settings.ini",
            "缺少 config/settings.ini",
            "mkdir config   然後   mv settings.ini config/",
        ),
        check(
            not os.path.exists(STRAY_CONFIG),
            "專案根目錄很乾淨，沒有散落的 settings.ini",
            "根目錄還躺著一份 settings.ini（要用 mv 搬走，不是 cp 複製）",
            "mv settings.ini config/    ← 用 mv，搬完原地就不會留下",
        ),
        check(
            os.path.isfile(LOGO),
            "找到 assets/logo.txt",
            "缺少 assets/logo.txt",
            "mkdir assets   然後   cp trash/logo.txt assets/",
        ),
        check(
            os.path.isfile(BACKUP_LOGO),
            "備份 trash/logo.txt 還在（TypeC 的心血保住了）",
            "備份 trash/logo.txt 不見了！那是唯一一份，要用 cp 不是 mv",
            "把它放回去：cp assets/logo.txt trash/logo.txt",
        ),
    ]

    failed = [fix for ok, fix in results if not ok]

    if failed:
        print(LINE)
        print("  \033[1;31m專案還是壞的。\033[0m 小拿斯留話：「照著下面做就好，不難。」")
        print(LINE)
        for fix in failed:
            print("    $ " + fix)
        print()
        print("  做完再跑一次：python3 main.py")
        print("  想確認檔案排對了沒：ls -R")
        print()
        sys.exit(1)

    parser = configparser.ConfigParser()
    parser.read(CONFIG, encoding="utf-8")

    try:
        club = parser.get("banner", "club_name")
        slogan = parser.get("banner", "slogan")
        status = parser.get("banner", "status")
    except Exception:
        print("  設定檔讀得到，但內容怪怪的。用 cat config/settings.ini 看看。")
        sys.exit(1)

    if status.strip() != "ready":
        print("  settings.ini 裡的 status 不是 ready，橫幅拒絕產生。")
        sys.exit(1)

    with open(LOGO, "r", encoding="utf-8") as f:
        logo = f.read().rstrip("\n")

    print(LINE)
    print("  \033[1;32m全部通過。專案修好了。\033[0m")
    print(LINE)
    print()
    print(logo)
    print()
    print("  %s" % club)
    print("  「%s」" % slogan)
    print()
    print(LINE)
    print("  LEVEL 4 CLEAR")
    print(LINE)
    print()
    print("    " + FLAG)
    print()
    print("----------------------------------------------------------------")
    print("[LEVEL 5] 最後一關：檔案庫")
    print()
    print("  最後一個 flag 在 ~/club_server/level5 的照片檔案庫裡。")
    print("  我警告你，那裡面有幾百個資料夾，一層一層點下去會瘋掉。")
    print()
    print("  這種時候要用 tree，它會把整個目錄畫成樹狀圖。")
    print("  但這台機器沒裝 tree —— 對，要你自己裝。這也是一課。")
    print()
    print("    sudo apt install tree")
    print()
    print("  詳細說明看：cat ~/club_server/level5/note.txt")
    print()
    print("                                        -- 小拿斯")
    print()


if __name__ == "__main__":
    main()
