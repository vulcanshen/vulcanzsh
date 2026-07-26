cpath() {
  if [ -z "$1" ]; then
    echo "Usage: cpath <file or dir>"
    return 1
  fi
  realpath "$1" | tr -d '\n' | pbcopy
}

compdef _files cpath
