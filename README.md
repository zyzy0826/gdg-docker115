# GDG Linux CTF Lab — 社團伺服器搶救行動

給 **Google Developer Group (on Campus)　開源技術開發研究社** 用的 Docker 化 Linux 闖關環境，
用來教大學生最基礎的 terminal 指令。

> 劇情：第四屆社長小拿斯畢業前一晚把伺服器搞得亂七八糟，官網掛了，
> 社團空窗一年。六個 flag 散落在各個角落，
> 剛上任的第五屆幹部（也就是玩的人）必須靠 terminal 把它救回來。

六關對應六組指令：`cd` / `ls -a` / `nano` + `python3` / `mkdir`+`mv`+`cp` / `apt install` / 編輯 JSON。
全部找齊後填進 `config.json`，官網（http://localhost:8080）就會從 **SYSTEM DEGRADED** 變回正常。

---

## 快速開始

```bash
docker compose up -d --build      # 建置並啟動（第一次約 1~2 分鐘）
docker compose exec gdg-lab bash  # 進入容器，開始闖關
```

進去之後會看到開場動畫，第一個指令是：

```bash
cat ~/hint.txt        # 或直接打 mission
```

官網：瀏覽器打開 <http://localhost:8080>

結束：

```bash
docker compose down          # 停掉（下次 up 會回到初始狀態）
docker compose down -v       # 連 volume 一起清掉（有啟用 volume 才需要）
```

**多人共用一台主機時**，把 `docker-compose.yml` 的 port 改成 `"8081:8080"` 之類，
或讓每個學生用自己的 project name：`docker compose -p student01 up -d`。

**打不開網頁？** 先確認容器有跑（`docker compose ps`），再試 <http://127.0.0.1:8080>。
如果 `127.0.0.1:8080` 通、`localhost:8080` 卻卡住，代表主機上已經有別的程式佔用了
IPv6 的 8080（瀏覽器解析 localhost 時會先走 `::1`）。查一下是誰：

```powershell
netstat -ano | findstr :8080        # Windows，最後一欄是 PID
```

最省事的解法是改用別的 port，例如把 compose 改成 `"8090:8080"`，然後開 <http://localhost:8090>。

---

## 關卡設計

| 關卡 | 教什麼 | 學生要做的事 |
|------|--------|--------------|
| 0 | `cat`、方向感 | 讀 `~/hint.txt`，拿到見面禮 flag |
| 1 | `cd` `pwd` `ls` `cat`、Tab 補完 | 走到 `level1/backup/old_stuff/` 讀 flag |
| 2 | `ls -a`、隱藏檔概念 | 在 `level2/` 找出 `.gdg_secret` |
| 3 | 執行腳本、`nano` 存檔、跑 python | 跑 NPC 腳本問密碼 → `nano key.txt` → `python3 decrypt.py` |
| 4 | `mkdir` `mv` `cp` 的差別、`ls -R` | 把 `broken_project/` 的檔案排回正確位置，跑 `main.py` |
| 5 | `sudo apt install`、`tree`（`-a`/`-L`）、`find` | 裝 tree，在幾百個資料夾裡挖出最深處的 flag |
| 終 | JSON 格式、`nano` 編輯設定檔 | 六個 flag 填進 `website/config.json`，官網復活 |

第 4 關特意設計成 **必須用 `mv`（根目錄不能留檔）** 和 **必須用 `cp`（備份不能消失）**，
逼學生分清楚搬移與複製；`main.py` 會逐項檢查並印出該打哪一行指令。

---

## NPC

| 腳本 | 角色 | 作用 |
|------|------|------|
| `~/club_server/npc/senior.sh` | typec-mini（TypeC 的分身模型） | 第 3 關的密碼來源，順便把步驟列給學生 |
| `~/club_server/npc/dahuang.sh` | 大黃（第三屆社長，現職 SRE） | 第 4 關的求救對象：整理五條原則 + 不給答案的方向指引 |
| `~/club_server/npc/sisi.sh` | 西西 | 只會嘻嘻。完全沒有提示，純彩蛋 |
| `~/club_server/npc/president.sh` | 小拿斯 | 純劇情語音留言，解釋他為什麼這樣做 |
| `~/club_server/npc/say.sh` | — | 共用的對話函式庫（顏色、逐行延遲、按 Enter 繼續） |

大黃是刻意設計的「反面聲音」：他不覺得把伺服器搞爛很浪漫，會直接說那是不負責任。
他給的五條原則（一個資料夾一件事、mv vs cp、動手前後都 ls -R、檔名要看得懂、rm 前先想）
就是第 4 關真正想教的東西，但他不會直接把指令排好給學生。

西西一句提示都不給，是給那些「每個腳本都要跑跑看」的學生的獎勵（或懲罰）。
他的存在在大黃、小拿斯、會議記錄、經費表裡都有伏筆。

### 時間軸與角色定位

| 屆別 | 年份 | 誰 | 現況 |
|------|------|----|------|
| 第一屆 | 2016 | — | 把社網架在宿舍桌機上 |
| 第二屆 | 2018 | — | 桌機搬進社辦，燒掉一顆硬碟 |
| 第三屆 | 2020–2021 | **大黃**（社長） | 已就業，SRE。每週三巡檢，看不慣小拿斯 |
| 第四屆 | 2022–2024 | **小拿斯**（社長）、**TypeC**（副社長）、**西西** | 2024/6/14 畢業當晚把伺服器打散成 CTF |
| — | 2024–2025 | 空窗一年，沒有人接 | 伺服器就這樣爛著 |
| 第五屆 | 2025 | **玩這個 lab 的人** | 剛上任，負責把它修回來 |

小拿斯大二（2022）寫了 `decrypt.py`，同年 TypeC 手工排出社徽 ASCII、
夏天辦了那場黑客松（第 5 關最深處的照片說明就是那次）。
大黃比他們早兩屆，是小拿斯的直屬學長——所以小拿斯日記裡那句
「我當年也罵過第三屆社長」，罵的就是大黃。

對話是**一行一行**慢慢印出來的（預設每行 0.9 秒）。趕時間可以快轉：

```bash
GDG_FAST=1 ./senior.sh          # 完全不延遲、不等 Enter
GDG_DELAY=0.3 ./president.sh    # 自訂每行秒數
```

---

## 彩蛋

* `~/todo.txt` — 小拿斯的待辦清單（密碼那行被咖啡漬蓋掉了）
* `~/.hall_of_fame.txt` — 隱藏檔，歷屆社長黑歷史 + ASCII 企鵝
* `~/club_server/diary/` — 兩篇日記，第二篇是畢業當天凌晨 4:12 寫的
* `~/club_server/level2/server.log` — 那天晚上的操作紀錄
* `level5` 裡兩個假 flag / 陷阱資料夾
* 最深處的 `hackathon_2022.txt` — 2022 年黑客松的照片說明
* 開場 banner、`.bashrc` 裡小拿斯的懶人 alias

---

## 答案（給助教，不要給學生）

<details>
<summary>點開看六個 flag 與路徑</summary>

| 關 | flag | 位置 |
|----|------|------|
| 0 | `GDG{h3ll0_t3rm1n4l_w0rld}` | `~/hint.txt` |
| 1 | `GDG{cd_1s_th3_f1rst_st3p}` | `~/club_server/level1/backup/old_stuff/flag.txt` |
| 2 | `GDG{d0tf1l3s_4r3_sn34ky}` | `~/club_server/level2/.gdg_secret` |
| 3 | `GDG{d3crypt3d_th3_l3g4cy}` | `decrypt.py` 解 `secret.enc`（密碼 `GDGVIP666`，由 `senior.sh` 給） |
| 4 | `GDG{pr0j3ct_r3st0r3d_g00d_j0b}` | 修好 `broken_project` 後 `python3 main.py` 印出 |
| 5 | `GDG{tr33_s33s_3v3ryth1ng}` | `level5/archive/2022/summer/photos/raw/hackathon_0713/.cache/thumbs/backup/final_v3_FINAL/flag.txt` |

第 4 關標準解：

```bash
cd ~/club_server/level4/broken_project
mkdir config assets
mv settings.ini config/
cp trash/logo.txt assets/
python3 main.py
```

第 5 關偷吃步：`find ~/club_server/level5 -name flag.txt` 或 `tree -a | grep flag`。

</details>

---

## 檔案結構

```
.
├── Dockerfile                 ubuntu:22.04 + nano/python3/sudo，建立 student 使用者
├── docker-compose.yml         port 8080，tty 開著
├── docker/
│   ├── bashrc                 彩色 PS1 + 開場 banner + alias
│   └── entrypoint.sh          背景啟動官網 http server
└── lab/
    ├── tools/build_maze.sh    build 時產生第 5 關的深層目錄迷宮
    └── home/                  → 整包複製進 /home/student
        ├── hint.txt           第 0 關
        ├── todo.txt
        ├── .hall_of_fame.txt
        └── club_server/
            ├── handover.txt   指令小抄
            ├── diary/         彩蛋
            ├── npc/           NPC 對話腳本
            ├── level1 ~ level5
            └── website/       index.html / style.css / app.js / config.json
```

---

## 幾個實作上的取捨

**`tree` 沒有預先安裝。** 第 5 關的重點就是讓學生自己跑 `sudo apt install tree`，
所以 Dockerfile 用 `apt-get install --download-only tree` 只把 `.deb` 下載進映像檔的
apt cache，並保留 `/var/lib/apt/lists`。結果是：**教室沒網路也裝得起來**，
學生跑 `sudo apt install tree` 會直接從本機 cache 安裝成功，體感跟真的裝套件一模一樣。
若你希望 tree 一開始就裝好，把 Dockerfile 裡的 `--download-only` 拿掉即可
（第 5 關會變成單純的「用 tree 找檔案」）。

**student 有免密碼 sudo。** 這是教學環境的刻意設計（第 5 關要用），
容器也只跑一個 http server，不要拿這個映像檔去跑正式服務。

**flag 驗證用雜湊。** `app.js` 存的是 flag 的 djb2 雜湊值而非明文，
學生 `cat app.js` 不會直接看到答案。這只是防「不小心瞄到」，不是真的安全機制。

**換 flag 內容的話**：改完各關檔案後，記得同步更新 `app.js` 裡的 `hash` 欄位。
產生方式（Node.js）：

```js
function hash(s){let x=5381;for(let i=0;i<s.length;i++){x=((x*33)^s.charCodeAt(i))>>>0;}return x.toString(16).padStart(8,'0');}
```

第 3 關的 `secret.enc` 是「明文 XOR 密碼 → base64」，要換內容用 Python 重新產生：

```python
import base64
key = "GDGVIP666"
msg = "新的內容"
b, k = msg.encode(), key.encode()
print(base64.b64encode(bytes(b[i] ^ k[i % len(k)] for i in range(len(b)))).decode())
```

**Windows 使用者注意**：專案內附 `.gitattributes` 強制 LF，
Dockerfile 也會再 `sed` 清一次 CRLF，所以 clone 到 Windows 再 build 不會爆。
