preview() {
  if [ -z "$1" ]; then
    echo "Usage: preview <file/dir>"
    return 1
  fi
  qlmanage -p "$@" &>/dev/null &
}

compdef _files preview
