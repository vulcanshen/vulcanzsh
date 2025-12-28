llv() {
  local level="${1:-1}"
  eza --tree --level="$level" --icons --group-directories-first --classify=always
}
