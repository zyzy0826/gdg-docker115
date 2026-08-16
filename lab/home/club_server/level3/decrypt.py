#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
小拿斯的解密工具（2019 年寫的，程式碼很醜，我知道，不要罵我）

用法:
    1. 把密碼寫進同一個資料夾裡的 key.txt
    2. python3 decrypt.py

原理很簡單：secret.enc 是「明文 XOR 密碼」之後再 base64 編碼。
解密就是反過來：base64 解碼 → 再 XOR 一次同樣的密碼。
XOR 兩次會變回原樣，這是它最可愛的地方。
"""

import base64
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
KEY_FILE = os.path.join(HERE, "key.txt")
ENC_FILE = os.path.join(HERE, "secret.enc")

LINE = "=" * 64


def die(title, *lines):
    print(LINE)
    print("  解密失敗：" + title)
    print(LINE)
    for line in lines:
        print(line)
    print()
    sys.exit(1)


def load_key():
    if not os.path.exists(KEY_FILE):
        die(
            "找不到 key.txt",
            "我在這個路徑找不到密碼檔：",
            "    %s" % KEY_FILE,
            "",
            "請照著做：",
            "    cd ~/club_server/level3",
            "    nano key.txt        （把密碼打進去）",
            "    Ctrl+O → Enter → Ctrl+X",
            "    python3 decrypt.py",
            "",
            "密碼不知道？去問 TypeC：bash ~/club_server/npc/senior.sh",
        )

    with open(KEY_FILE, "r", encoding="utf-8", errors="replace") as f:
        raw = f.read()

    # 取第一行非空白的內容，順便把學生可能不小心貼進來的引號拿掉
    key = ""
    for line in raw.splitlines():
        if line.strip():
            key = line.strip().strip("\"'")
            break

    if not key:
        die(
            "key.txt 是空的",
            "檔案存在，但裡面什麼都沒有。",
            "在 nano 裡面「打完字」之後要按 Ctrl+O 存檔，才會真的寫進檔案。",
            "存完可以用 cat key.txt 確認一下。",
        )

    return key


def main():
    key = load_key()

    with open(ENC_FILE, "r", encoding="ascii") as f:
        blob = "".join(f.read().split())

    try:
        data = base64.b64decode(blob)
    except Exception:
        die("secret.enc 壞掉了", "這個檔案被改過或損毀了，去跟助教要一份原始檔。")

    kb = key.encode("utf-8")
    plain = bytes(b ^ kb[i % len(kb)] for i, b in enumerate(data))

    try:
        text = plain.decode("utf-8")
    except UnicodeDecodeError:
        text = None

    if text is None or "GDG{" not in text:
        die(
            "密碼不對",
            "你給我的密碼是：%r" % key,
            "",
            "解出來是一堆亂碼，代表這串不是正確的密碼。",
            "檢查一下：",
            "  * 全部小寫了嗎",
            "  * 中間是底線 _ 不是減號 -",
            "  * key.txt 裡面有沒有多打「密碼是」之類的字",
            "",
            "用 cat key.txt 看看你到底存了什麼。",
            "再問一次 TypeC：bash ~/club_server/npc/senior.sh",
        )

    print()
    print(text)
    print()


if __name__ == "__main__":
    main()
