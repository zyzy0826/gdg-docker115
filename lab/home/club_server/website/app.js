/* 官網啟動程式
 *
 * 它每 3 秒去讀一次 config.json，檢查六個修復碼（flag）對不對。
 * 全對 → 官網內容出現；沒對 → 停在 SYSTEM COMPROMISED 畫面。
 *
 * 小拿斯註：flag 我當然不會明文寫在這裡，不然你直接 cat app.js 就破台了。
 *          這裡存的是雜湊值（hash），單向的，看得到也還原不回去。
 *          （好啦，理論上可以暴力破解。你要是真的會寫爆破腳本，
 *            那你早就不需要這個 lab 了，社長之位是你的。）
 */

var LEVELS = [
  { key: "level0", name: "NODE 0", desc: "cat · 讀取遺留訊息",          hash: "ad445dae" },
  { key: "level1", name: "NODE 1", desc: "cd · 深入 backup/old_stuff",  hash: "195ab04b" },
  { key: "level2", name: "NODE 2", desc: "ls -a · 隱藏檔",              hash: "ad1e2b81" },
  { key: "level3", name: "NODE 3", desc: "nano + decrypt.py · 解密",    hash: "177bb792" },
  { key: "level4", name: "NODE 4", desc: "apt install tree · 深層搜尋", hash: "664a7758" },
  { key: "level5", name: "NODE 5", desc: "mkdir / mv / cp · 修復專案",  hash: "c67e70cc" }
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
      note = "這個修復碼不對，檢查有沒有打錯字或漏掉大括號";
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
    title.textContent = "SYSTEM ONLINE";
    title.setAttribute("data-text", "SYSTEM ONLINE");
    title.classList.add("ok");
    $("lead").textContent = "6 個安全節點全部修復。伺服器狀態恢復正常，官網內容已載入。";
    $("hintBox").textContent =
      "剩下的事：\n" +
      "  * 回 terminal 看看 ~/club_server/diary/ 裡的日記（如果你還沒看的話）\n" +
      "  * ls -a ~ 看看家目錄還有什麼隱藏的東西\n" +
      "  * 然後把這台伺服器交給下一屆的時候，記得整理乾淨。或者不要。";
    dot.classList.add("ok");
    $("statusText").textContent = "status: ONLINE · 6/6 nodes secured";
    $("site").classList.remove("hidden");
    applySite(config);
  } else {
    title.textContent = "SYSTEM COMPROMISED";
    title.setAttribute("data-text", "SYSTEM COMPROMISED");
    title.classList.remove("ok");
    $("lead").textContent =
      "還有 " + (LEVELS.length - solved) + " 個安全節點離線，官網無法載入內容。";
    $("hintBox").textContent =
      "在容器裡用 submit GDG{...} 提交修復碼，會自動寫進 config.json。\n" +
      "這個頁面每 3 秒重讀一次，交完就會更新。不知道下一步？輸入 mission。";
    dot.classList.remove("ok");
    $("statusText").textContent = "status: COMPROMISED · " + solved + "/6 nodes secured";
    $("site").classList.add("hidden");
  }
}

function applySite(config) {
  var site = (config && config.site) || {};
  if (site.club_name_en) { $("clubNameEn").textContent = site.club_name_en; }
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
  $("lead").textContent = "config.json 讀得到，但格式不合法，所以還沒辦法檢查修復碼。";
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
