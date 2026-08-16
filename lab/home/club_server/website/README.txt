社團官網 · 檔案說明
====================

  index.html    網頁本體
  style.css     樣式（我大二寫的，很醜，但我不准你改）
  app.js        會去讀 config.json，檢查六個 flag 對不對
  config.json   ← 你要動的就是這個

網站已經在容器裡跑起來了（python3 -m http.server 8080），
你在自己電腦的瀏覽器打開 http://localhost:8080 就看得到。

修法：
    nano config.json
把六個 flag 填進去，存檔（Ctrl+O → Enter → Ctrl+X），瀏覽器重新整理。
（網頁每 3 秒會自己重讀一次 config.json，其實你不重新整理也會變。）

JSON 打壞了不要慌，網頁會直接告訴你錯在哪。
真的救不回來：cat 這個檔案旁邊沒有備份，但重開容器就會回到原狀。

                                        -- 小拿斯
