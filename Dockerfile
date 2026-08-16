FROM ubuntu:22.04

LABEL org.opencontainers.image.title="GDG Linux CTF Lab"
LABEL org.opencontainers.image.description="社團伺服器搶救行動 - 給大學生的 Linux 指令闖關環境"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=Asia/Taipei

# ---------------------------------------------------------------------------
# apt 設定：保留已下載的 .deb 與套件索引。
# 第 5 關要學生自己跑 `sudo apt install tree`，所以 tree 只「下載不安裝」，
# 這樣就算教室沒網路，apt 也能直接從本機 cache 裝起來。
# ---------------------------------------------------------------------------
RUN rm -f /etc/apt/apt.conf.d/docker-clean \
 && printf 'Binary::apt::APT::Keep-Downloaded-Packages "true";\n' \
      > /etc/apt/apt.conf.d/99keep-downloaded-packages

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      nano \
      python3 \
      sudo \
      less \
      file \
      ca-certificates \
      bash-completion \
 && apt-get install -y --download-only tree \
 && rm -rf /var/lib/apt/lists/partial

# ---------------------------------------------------------------------------
# 建立 student 使用者（密碼 gdg，可用 sudo，第 5 關要用）
# ---------------------------------------------------------------------------
RUN useradd -m -s /bin/bash student \
 && echo 'student:gdg' | chpasswd \
 && usermod -aG sudo student \
 && echo 'student ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/99-student \
 && chmod 0440 /etc/sudoers.d/99-student

# ---------------------------------------------------------------------------
# 關卡內容
# ---------------------------------------------------------------------------
COPY lab/home/ /home/student/
COPY docker/bashrc /home/student/.bashrc
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY lab/tools/build_maze.sh /tmp/build_maze.sh

# Windows 上 clone 可能帶進 CRLF，這裡統一清掉，否則 bash / python 會爆
RUN find /home/student /usr/local/bin/entrypoint.sh /tmp/build_maze.sh \
      -type f \( -name '*.sh' -o -name '*.py' \) -exec sed -i 's/\r$//' {} + \
 && chmod +x /usr/local/bin/entrypoint.sh /tmp/build_maze.sh \
 && find /home/student -type f -name '*.sh' -exec chmod +x {} + \
 && bash /tmp/build_maze.sh /home/student/club_server/level5 \
 && rm -f /tmp/build_maze.sh \
 && chown -R student:student /home/student

USER student
WORKDIR /home/student

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]
