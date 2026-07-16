cld() {
  if [ -z "$1" ]; then
    claude
  else
    claude --resume "$1"
  fi
}
