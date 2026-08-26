preview() {
  if [ -z "$1" ]; then
    echo "Usage: preview <file>"
    return 1
  fi
  open -a Preview "$@"
}

compdef _files preview
