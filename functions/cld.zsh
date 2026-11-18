# cld                   → claude
# cld <目錄> [參數...]  → cd <目錄>（zoxide 的 cd，可用關鍵字）後 claude -c [參數...]，接續該目錄最近一次對話
# cld -<參數> ...       → 原樣交給 claude（例如 cld -r <session>）
cld() {
  if [[ -n $1 && $1 != -* ]]; then
    cd "$1" || return
    shift
    claude -c "$@"
  else
    claude "$@"
  fi
}
