for f in ${0:h}/*.zsh; do
  [[ "$f" != "$0" ]] && source "$f"
done
