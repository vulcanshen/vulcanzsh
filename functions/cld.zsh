# cld                   → claude
# cld <名稱> [參數...]  → 有 session 叫 <名稱>（/rename 取的，完整相符）：切到它的目錄，claude --resume 那個 session
#                         沒有的話把 <名稱> 當目錄，切過去後 claude -c，接續該目錄最近一次對話；
#                         目錄依序找：真實路徑 → 目前位置上層的同名目錄 → zoxide（可用關鍵字）
# cld -<參數> ...       → 原樣交給 claude（例如 cld -r <session>）
cld() {
  if [[ -n $1 && $1 != -* ]]; then
    local name=$1 here=$PWD/ dir s
    shift
    if s=$(_cld_session "$name"); then
      cd "${s#*$'\t'}" || return
      claude --resume "${s%%$'\t'*}" "$@"
      return
    fi
    dir=$name
    if [[ ! -d $dir ]]; then
      if [[ $here == */$name/* ]]; then
        # 在 abc/docs 裡 cld abc：就是上層那個 abc，不必靠 zoxide 有沒有記錄
        dir=${here%/$name/*}/$name
      else
        # 直接 query、不經 zoxide 的 cd：後者會把目前目錄排除在結果外，
        # 在 abc 裡 cld abc 會報錯，或跳到同名開頭的別的目錄（例如 abc-go）
        dir=$(zoxide query -- "$name") || return
      fi
    fi
    cd "$dir" || return
    claude -c "$@"
  else
    claude "$@"
  fi
}

# 找最近一個名稱完全相符的 session（/rename 寫進對話檔的 custom-title），印出「session-id<TAB>目錄」。
# Claude Code 會把名稱重寫在對話檔結尾附近，所以每個檔只讀最後 64KB，不用掃整個 ~/.claude/projects；
# 檔案從新到舊讀，找到就停。目錄取檔頭第一筆 cwd（對話開始的目錄；中途 cd 過的話，檔尾的 cwd 可能是子目錄）。
_cld_session() {
  local f dir
  f=$(tail -c 65536 -- ~/.claude/projects/*/*.jsonl(Nom) 2>/dev/null \
    | LC_ALL=C grep -a -E '^==> .* <==$|"type":"custom-title"' \
    | LC_ALL=C awk -v want="\"customTitle\":\"$1\"" '
        /^==> .* <==$/ { if (hit) exit; file = substr($0, 5, length($0) - 8); next }
        { hit = index($0, want) > 0 }
        END { if (hit) print file }')
  [[ -n $f ]] || return 1
  dir=$(head -c 65536 -- "$f" | LC_ALL=C grep -a -o -m1 '"cwd":"[^"]*"' | head -1)
  dir=${${dir#\"cwd\":\"}%\"}
  [[ -n $dir ]] || return 1
  print -r -- "${f:t:r}"$'\t'"$dir"
}
