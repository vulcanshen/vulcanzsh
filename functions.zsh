ssh() {
    TERM=xterm-256color command ssh "$@"
}

mtp() {
    TERM=xterm-256color command multipass "$@"
}

chrome() { open -a "Google Chrome" "$@"; }
