tmux_rename_window() {
  local name
  name=$(printf '' | fzf --print-query --prompt='Rename window (enter to reset auto): ' | head -1)
  if [[ -n "$name" ]]; then
    tmux rename-window "$name"
    tmux set-window-option automatic-rename off
  else
    tmux set-window-option automatic-rename on
  fi
}

tmux_session_picker() {
  local is_entrance=${1:-false}
  local current_session selected sessions options
  current_session=$(tmux display-message -p '#{session_name}')

  local esc_bind
  [[ "$is_entrance" == true ]] && esc_bind="esc:ignore" || esc_bind="esc:abort"

  sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -v "^${current_session}$")
  options="[New Session]"
  [[ -n "$sessions" ]] && options+=$'\n'"$sessions"

  selected=$(printf '%s\n' "$options" | fzf --reverse --prompt='Session: ' --no-info --bind "$esc_bind")
  [[ -z "$selected" ]] && return  # ESC or Ctrl-C

  if [[ "$selected" == "[New Session]" ]]; then
    tmux setenv -g _TMUX_NEW_SESSION_REQUESTED 1
  else
    tmux switch-client -t "$selected"
    if [[ "$is_entrance" == true ]]; then
      tmux setenv -g _TMUX_PICKER_CLOSING 1
      tmux kill-session -t "$current_session"
    fi
  fi
}

tmux_new_session_input() {
  local is_entrance=${1:-false}
  local from_session=${2:-}
  local header="" new_name num

  while true; do
    local fzf_args=(--reverse --print-query --prompt='Session name (enter for auto): ' --no-info --bind 'esc:abort')
    [[ -n "$header" ]] && fzf_args+=(--header "$header")
    new_name=$(printf '' | fzf "${fzf_args[@]}" 2>/dev/null | head -1)

    if [[ -z "$new_name" ]]; then
      local words=(
        zeus ares athena apollo hermes hades poseidon demeter dionysus artemis
        hera kronos atlas prometheus erebus chaos nyx helios selene eos
        achilles odysseus perseus orpheus icarus medusa hydra phoenix sphinx titan olympus
        odin thor loki freya tyr heimdall baldur frigg njord skadi
        vidar bragi fenrir sleipnir huginn muninn hel nidhogg asgard valhalla bifrost sigurd ragnarok
      )
      local word=${words[$((RANDOM % ${#words[@]} + 1))]}
      num=1
      while tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -q "^${num}-"; do
        num=$((num + 1))
      done
      new_name="${num}-${word}"
    fi

    if tmux has-session -t "$new_name" 2>/dev/null; then
      header="⚠ '$new_name' already exists, try another name"
      continue
    fi
    break
  done

  tmux new-session -d -s "$new_name"
  tmux switch-client -t "$new_name"
  if [[ "$is_entrance" == true ]]; then
    tmux setenv -g _TMUX_PICKER_CLOSING 1
    tmux kill-session -t "$from_session"
  fi
}

_tmux_after_picker() {
  local is_entrance=${1:-false}
  local from_session=${2:-}

  if tmux showenv -g _TMUX_NEW_SESSION_REQUESTED 2>/dev/null | grep -q '=1'; then
    tmux setenv -gu _TMUX_NEW_SESSION_REQUESTED
    tmux display-popup -b rounded -h 3 -w 50 \
      -x C -y C \
      -S "fg=#89b4fa" \
      -E "zsh -c 'source ~/.config/vulcanzsh/modules/tmux-workflow.zsh && tmux_new_session_input $is_entrance $from_session'"
  fi
}

tmux_s_flow() {
  tmux setenv -gu _TMUX_NEW_SESSION_REQUESTED
  tmux display-popup -b rounded -w 50 \
    -x C -y C \
    -S "fg=#89b4fa" \
    -E "zsh -c 'source ~/.config/vulcanzsh/modules/tmux-workflow.zsh && tmux_session_picker'"
  _tmux_after_picker false
}

tmux_entrance() {
  local entrance_session
  entrance_session=$(tmux display-message -p '#{session_name}')
  tmux setenv -gu _TMUX_NEW_SESSION_REQUESTED
  tmux display-popup -b rounded -w 50 \
    -x C -y C \
    -S "fg=#89b4fa" \
    -E "zsh -c 'source ~/.config/vulcanzsh/modules/tmux-workflow.zsh && tmux_session_picker true'"
  _tmux_after_picker true "$entrance_session"
}

tmux_on_session_close() {
  if tmux showenv -g _TMUX_PICKER_CLOSING 2>/dev/null | grep -q '=1'; then
    tmux setenv -gu _TMUX_PICKER_CLOSING
    return
  fi
  local count
  count=$(tmux list-sessions 2>/dev/null | wc -l | tr -d ' ')
  if [[ "$count" -gt 1 ]]; then
    tmux setenv -gu _TMUX_NEW_SESSION_REQUESTED
    tmux display-popup -b rounded -w 50 \
      -x C -y C \
      -S "fg=#89b4fa" \
      -E "zsh -c 'source ~/.config/vulcanzsh/modules/tmux-workflow.zsh && tmux_session_picker'"
    _tmux_after_picker false
  fi
}

if [[ -z "$TMUX" ]]; then
  # Skip if a user is already attached to tmux (shell spawned by a third-party app like OrbStack)
  if tmux list-clients -F '#{session_name}' 2>/dev/null | grep -qv '^entrance'; then
    return 2>/dev/null || exit 0
  fi

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
    "zsh -c 'source ~/.config/vulcanzsh/modules/tmux-workflow.zsh && tmux_entrance'"
  exec tmux attach -t "$_entrance"
fi
