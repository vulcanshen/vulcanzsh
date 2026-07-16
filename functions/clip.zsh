clip() {
  if [ -z "$1" ]; then
    echo "Usage: clip <file>"
    return 1
  fi
  local file="$(realpath "$1")"
  if [ ! -f "$file" ]; then
    echo "Error: file not found: $file"
    return 1
  fi
  osascript -e "set the clipboard to (POSIX file \"$file\")"
  echo "Copied: $file"
}
