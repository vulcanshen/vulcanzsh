ssh() {
    TERM=xterm-256color command ssh "$@"
}

mtp() {
    TERM=xterm-256color command multipass "$@"
}

chrome() { open -a "Google Chrome" "$@"; }

chromedev() { open -na "Google Chrome" --args --disable-web-security --user-data-dir="/tmp/chrome_dev" "$@"; }

cld() {
  if [ -z "$1" ]; then
    claude
  else
    claude --resume "$1"
  fi
}
