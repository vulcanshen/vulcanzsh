# cld                   → claude
# cld <目錄> [參數...]  → 切到 <目錄> 後 claude -c [參數...]，接續該目錄最近一次對話
#                         <目錄> 依序找：真實路徑 → 目前位置上層的同名目錄 → zoxide（可用關鍵字）
# cld -<參數> ...       → 原樣交給 claude（例如 cld -r <session>）
cld() {
  if [[ -n $1 && $1 != -* ]]; then
    local dir=$1 here=$PWD/
    if [[ ! -d $dir ]]; then
      if [[ $here == */$1/* ]]; then
        # 在 abc/docs 裡 cld abc：就是上層那個 abc，不必靠 zoxide 有沒有記錄
        dir=${here%/$1/*}/$1
      else
        # 直接 query、不經 zoxide 的 cd：後者會把目前目錄排除在結果外，
        # 在 abc 裡 cld abc 會報錯，或跳到同名開頭的別的目錄（例如 abc-go）
        dir=$(zoxide query -- "$1") || return
      fi
    fi
    cd "$dir" || return
    shift
    claude -c "$@"
  else
    claude "$@"
  fi
}
