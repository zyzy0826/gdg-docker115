/* 官網啟動程式
 *
 * 它每 3 秒去讀一次 config.json，檢查六個 flag 對不對。
 * 全對 → 官網內容出現；沒對 → 停在 SYSTEM DEGRADED 畫面。
 *
 * 小拿斯註：flag 我當然不會明文寫在這裡，不然你直接 cat app.js 就破台了。
 *          這裡存的是雜湊值（hash），單向的，看得到也還原不回去。
 *          （好啦，理論上可以暴力破解。你要是真的會寫爆破腳本，
 *            那你早就不需要這個 lab 了，社長之位是你的。）
 */

var LEVELS = [
  { key: "level0", name: "LEVEL 0", desc: "hint.txt · 見面禮",           hash: "ad445dae" },
  { key: "level1", name: "LEVEL 1", desc: "cd · 走進 backup/old_stuff",  hash: "195ab04b" },
  { key: "level2", name: "LEVEL 2", desc: "ls -a · 隱藏檔",              hash: "ad1e2b81" },
  { key: "level3", name: "LEVEL 3", desc: "NPC + nano + decrypt.py",     hash: "177bb792" },
  { key: "level4", name: "LEVEL 4", desc: "mkdir / mv / cp · 修復專案",  hash: "c67e70cc" },
  { key: "level5", name: "LEVEL 5", desc: "apt install tree · 深層目錄", hash: "664a7758" }
];

/* djb2 變形雜湊，夠用就好 */
function hash(str) {
  var x = 5381;
  for (var i = 0; i < str.length; i++) {
    x = ((x * 33) ^ str.charCodeAt(i)) >>> 0;
  }
  var hex = x.toString(16);
  while (hex.length < 8) { hex = "0" + hex; }
  return hex;
}

var $ = function (id) { return document.getElementById(id); };

function render(config) {
  $("jsonError").classList.add("hidden");

  var flags = (config && config.flags) || {};
  var list = $("checklist");
  list.innerHTML = "";
  var solved = 0;

  LEVELS.forEach(function (lv) {
    var raw = flags[lv.key];
    var value = (typeof raw === "string" ? raw : "").trim();
    var state, mark, note;

    if (!value) {
      state = "empty";
      mark = "[ ]";
      note = "尚未填寫";
    } else if (hash(value) === lv.hash) {
      state = "ok";
      mark = "[✓]";
      note = lv.desc;
      solved++;
    } else {
      state = "bad";
      mark = "[✗]";
      note = "這個 flag 不對，檢查有沒有打錯字或漏掉大括號";
    }

    var li = document.createElement("li");
    li.className = state;
    li.innerHTML =
      '<span class="mark">' + mark + "</span>" +
      '<span class="lv">' + lv.name + "</span>" +
      '<span class="desc"></span>';
    li.querySelector(".desc").textContent = note;
    list.appendChild(li);
  });

  var pct = Math.round((solved / LEVELS.length) * 100);
  $("progressFill").style.width = pct + "%";
  $("progressLabel").textContent = solved + " / " + LEVELS.length;

  var done = solved === LEVELS.length;
  var title = $("bigTitle");
  var dot = $("statusDot");

  if (done) {
    title.textContent = "SYSTEM RESTORED";
    title.setAttribute("data-text", "SYSTEM RESTORED");
    title.classList.add("ok");
    $("lead").textContent = "六個 flag 全部正確。伺服器狀態恢復正常，官網內容已載入。";
    $("hintBox").textContent =
      "剩下的事：\n" +
      "  * 回 terminal 看看 ~/club_server/diary/ 裡的日記（如果你還沒看的話）\n" +
      "  * ls -a ~ 看看家目錄還有什麼隱藏的東西\n" +
      "  * 然後把這台伺服器交給下一屆的時候，記得整理乾淨。或者不要。";
    dot.classList.add("ok");
    $("statusText").textContent = "status: ONLINE · 6/6 flags verified";
    $("site").classList.remove("hidden");
    applySite(config);
  } else {
    title.textContent = "SYSTEM DEGRADED";
    title.setAttribute("data-text", "SYSTEM DEGRADED");
    title.classList.remove("ok");
    $("lead").textContent =
      "config.json 裡的六個 flag 沒有填齊，官網無法載入內容。";
    $("hintBox").textContent =
      "在容器裡執行：nano ~/club_server/website/config.json\n" +
      "把六個 flag 填進去，存檔之後這個頁面會自己更新（每 3 秒重讀一次）。";
    dot.classList.remove("ok");
    $("statusText").textContent = "status: DEGRADED · " + solved + "/6 flags verified";
    $("site").classList.add("hidden");
  }
}

function applySite(config) {
  var site = (config && config.site) || {};
  if (site.club_name) { $("clubName").textContent = site.club_name; }
  if (site.slogan) { $("slogan").textContent = site.slogan; }
  var bits = [];
  if (site.founded) { bits.push("since " + site.founded); }
  if (site.contact) { bits.push(site.contact); }
  $("meta").textContent = bits.join("　·　");
}

function showJsonError(message) {
  $("site").classList.add("hidden");
  $("jsonError").classList.remove("hidden");
  $("jsonErrorMsg").textContent = message;
  $("statusDot").classList.remove("ok");
  $("statusText").textContent = "status: CONFIG PARSE ERROR";
  $("bigTitle").textContent = "CONFIG BROKEN";
  $("bigTitle").setAttribute("data-text", "CONFIG BROKEN");
  $("bigTitle").classList.remove("ok");
  $("lead").textContent = "config.json 讀得到，但格式不合法，所以還沒辦法檢查 flag。";
}

function poll() {
  fetch("config.json?_=" + Date.now(), { cache: "no-store" })
    .then(function (res) {
      if (!res.ok) { throw new Error("HTTP " + res.status + "：讀不到 config.json"); }
      return res.text();
    })
    .then(function (text) {
      var config;
      try {
        config = JSON.parse(text);
      } catch (err) {
        showJsonError(String(err.message || err));
        return;
      }
      render(config);
    })
    .catch(function (err) {
      showJsonError(String(err.message || err));
    });
}

var beat = 0;
setInterval(function () {
  beat = (beat + 1) % 4;
  $("tick").textContent = "auto-check: on" + new Array(beat + 1).join(".");
}, 500);

poll();
setInterval(poll, 3000);
