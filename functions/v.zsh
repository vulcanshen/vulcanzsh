v() {
  if [ -z "$1" ]; then
    nvim .
    return
  fi

  if [ -d "$1" ]; then
    cd "$1" && nvim . && cd - >/dev/null
  else

    local dir=$(dirname "$1")
    local file=$(basename "$1")

    if [ ! -d "$dir" ]; then
      echo "Error: directory '$dir' not existed"
      return 1
    fi

    cd "$dir" && nvim "$file" && cd - >/dev/null
  fi
}
