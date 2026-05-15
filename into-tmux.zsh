tmux_session_picker() {
  local is_entrance=${1:-false}
  local current_session selected sessions options new_name header num
  current_session=$(tmux display-message -p '#{session_name}')

  local esc_bind
  [[ "$is_entrance" == true ]] && esc_bind="esc:ignore" || esc_bind="esc:abort"

  while true; do
    sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -v "^${current_session}$")
    options="[New Session]"
    [[ -n "$sessions" ]] && options+=$'\n'"$sessions"

    selected=$(printf '%s\n' "$options" | fzf --reverse --prompt='Session: ' --no-info --bind "$esc_bind")
    [[ -z "$selected" ]] && return  # ESC (non-entrance) or Ctrl-C

    if [[ "$selected" == "[New Session]" ]]; then
      header=""
      while true; do
        local fzf_args=(--reverse --print-query --prompt='New session name (enter for auto): ' --no-info --bind "$esc_bind")
        [[ -n "$header" ]] && fzf_args+=(--header "$header")
        new_name=$(printf '' | fzf "${fzf_args[@]}" 2>/dev/null | head -1)

        if [[ -z "$new_name" ]]; then
          num=1
          while tmux has-session -t "$num" 2>/dev/null; do num=$((num + 1)); done
          new_name="$num"
        fi

        if tmux has-session -t "$new_name" 2>/dev/null; then
          header="⚠ '$new_name' already exists, try another name"
          continue
        fi
        break
      done

      tmux new-session -d -s "$new_name"
      tmux switch-client -t "$new_name"
      [[ "$is_entrance" == true ]] && tmux kill-session -t "$current_session"
      return
    else
      tmux switch-client -t "$selected"
      [[ "$is_entrance" == true ]] && tmux kill-session -t "$current_session"
      return
    fi
  done
}

tmux_entrance() {
  tmux display-popup -b rounded -w 50 \
    -x '#{popup_centre_x}' -y '#{popup_centre_y}' \
    -S "fg=#89b4fa" \
    -E "zsh -c 'source ~/.config/vulcanzsh/into-tmux.zsh && tmux_session_picker true'"
}

if [[ -z "$TMUX" ]]; then
  # Clean up detached entrance sessions
  tmux list-sessions -F '#{session_name} #{session_attached}' 2>/dev/null \
    | awk '$1 ~ /^entrance(-[0-9]+)?$/ && $2 == 0 {print $1}' \
    | while read -r _s; do tmux kill-session -t "$_s" 2>/dev/null; done

  # Find available entrance name
  _entrance="entrance"
  _n=1
  while tmux has-session -t "$_entrance" 2>/dev/null; do
    _entrance="entrance-$_n"
    _n=$((_n + 1))
  done
  unset _n

  tmux new-session -d -s "$_entrance" \
    "zsh -c 'source ~/.config/vulcanzsh/into-tmux.zsh && tmux_entrance'"
  exec tmux attach -t "$_entrance"
fi
