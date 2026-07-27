autoload -Uz add-zsh-hook

# zsh's history file has no exit-code field, so a failed command can only be
# pruned after the fact: strip the line it just wrote, then reload memory
# from disk. Doing this via zshaddhistory instead (deferring the file write)
# fights SHARE_HISTORY's own incremental sync and corrupts the history file.
_history_skip_failed() {
  local exit_status=$?
  if (( exit_status != 0 )); then
    sed -i '' -e '$d' "$HISTFILE"
    fc -R "$HISTFILE"
  fi
}
add-zsh-hook precmd _history_skip_failed
