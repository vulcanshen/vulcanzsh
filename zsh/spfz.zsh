spzf() {
  local target
  target=$(fzf --preview '[[ -d {} ]] && ls -F {} || cat {}')
 # target=$(fzf)

  if [ -n "$target" ]; then
    if [ -d "$target" ]; then
      spf "$target"
    else
      spf "$(dirname "$target")"
    fi
  fi
}
