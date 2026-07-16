# llv [-lv N] [path...]  — eza tree view, default depth 1
llv() {
  local level=1
  local -a paths
  while (( $# )); do
    case "$1" in
      -lv)
        [[ -n "$2" ]] || { echo "llv: -lv needs a number" >&2; return 1; }
        level="$2"; shift 2 ;;
      *)
        paths+=("$1"); shift ;;
    esac
  done
  eza --tree --level="$level" --icons --group-directories-first --classify=always "${paths[@]}"
}

# tab completion: paths like `ls`, plus the -lv depth flag
_llv() {
  _arguments \
    '-lv[tree depth level]:level:(1 2 3 4 5)' \
    '*:path:_files'
}
compdef _llv llv
