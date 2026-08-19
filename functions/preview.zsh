preview() {
  if [ -z "$1" ]; then
    echo "Usage: preview <file/dir>"
    return 1
  fi
  qlmanage -p "$@" &>/dev/null &
  disown
  osascript -e 'tell application "System Events" to set frontmost of process "qlmanage" to true' &>/dev/null
}

compdef _files preview
