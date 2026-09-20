# GDG Linux CTF Lab — 社團伺服器搶救行動

給 **Google Developer Group on Campus　開源技術開發研究社** 用的 Docker 化 Linux 闖關環境，
用來練習最基礎的 terminal 指令。

> 上一任社長畢業那天把伺服器「整理」了一遍，官網從此掛掉。
> 他留下一張便條紙，說這是給下一屆的畢業禮物。
> 找出散落在系統各處的 6 個 flag，把官網救回來。

---

## 需要準備

* 安裝 [Docker Desktop](https://www.docker.com/products/docker-desktop/)（Windows / macOS）或 Docker Engine（Linux），並確認它正在執行
* 一個瀏覽器

---

## 快速開始

在這個資料夾裡打開 terminal（Windows 可用 PowerShell），執行：

```bash
docker compose up -d --build      # 建置並啟動（第一次約 1~2 分鐘）
docker compose exec gdg-lab bash  # 進入容器，開始闖關
```

進去之後會看到開場訊息，照著做就好：

```bash
cat ~/hint.txt           # 讀前社長留下的便條紙
mission                  # 查看進度和目前該做什麼
submit GDG{...}          # 交出找到的 flag
```

官網：瀏覽器打開 <http://localhost:8080>，修復進度會即時顯示在上面。

離開容器打 `exit`，之後想繼續玩再執行一次 `docker compose exec gdg-lab bash`。

---

## 結束

```bash
docker compose down          # 停掉容器（進度會清空，下次 up 從頭開始）
docker compose down -v       # 連 volume 一起清掉（有啟用 volume 才需要）
```

---

## 常見問題

**進度會不見嗎？** 只要沒有執行 `docker compose down`，關掉 terminal 或重開電腦後再
`docker compose up -d` 都會保留進度。想讓 `down` 之後也保留，
把 `docker-compose.yml` 最下面 `volumes` 的註解拿掉。

**打不開網頁？** 先確認容器有跑（`docker compose ps`），再試 <http://127.0.0.1:8080>。
如果 `127.0.0.1:8080` 通、`localhost:8080` 卻卡住，代表電腦上已經有別的程式佔用了
IPv6 的 8080（瀏覽器解析 localhost 時會先走 `::1`）。查一下是誰：

```powershell
netstat -ano | findstr :8080        # Windows，最後一欄是 PID
```

```bash
lsof -i :8080                       # macOS / Linux
```

**8080 port 被佔用、`docker compose up` 失敗？** 最省事的解法是換一個 port：
把 `docker-compose.yml` 裡的 `"8080:8080"` 改成 `"8090:8080"`，
重新 `docker compose up -d`，然後開 <http://localhost:8090>。

**`docker compose` 指令找不到？** 舊版 Docker 要用 `docker-compose`（中間有連字號）。

**卡關了？** 在容器裡輸入 `mission`，它會告訴你目前該做什麼。

**不小心把檔案弄壞了？** `docker compose down` 再 `docker compose up -d --build`，一切回到初始狀態。

---

## 多人共用一台主機

每個人需要不同的 port 和不同的 project name，例如：

```bash
docker compose -p student01 up -d --build
docker compose -p student01 exec gdg-lab bash
```

並把 `docker-compose.yml` 的 port 改成各自的號碼（`"8081:8080"`、`"8082:8080"`……），
同時把 `container_name` 那一行刪掉，避免容器名稱衝突。
