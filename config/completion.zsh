source <(kubectl completion zsh)
eval "$(task --completion zsh)"

#compdef gitlab-ci-local
###-begin-gitlab-ci-local-completions-###
#
# yargs command completion script
#
# Installation: /opt/homebrew/bin/gitlab-ci-local completion >> ~/.zshrc
#    or /opt/homebrew/bin/gitlab-ci-local completion >> ~/.zprofile on OSX.
#
_gitlab-ci-local_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" /opt/homebrew/bin/gitlab-ci-local --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gitlab-ci-local_yargs_completions gitlab-ci-local
###-end-gitlab-ci-local-completions-###

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/tofu tofu

# Docker CLI completions
fpath=($HOME/.docker/completions $fpath)

fpath=(~/.zsh/completions $fpath)
# dump 不存在或超過 24h → 完整重建（掃到新補全）；否則走 -C 快取。
# 想立刻套用新裝工具的補全時，用 `reloadcomp` 手動重建。
autoload -Uz compinit
if [[ ! -f ~/.zcompdump || -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# ------------------------------------------------------------------------------
# 全域補全樣式（2026-07 由 fzf-tab-enhancement.zsh 搬移至此，與 fzf-tab 無關）
# ------------------------------------------------------------------------------
# 用 vivid 產生高品質 LS_COLORS（ls/eza/補全清單配色）
export LS_COLORS=$(vivid generate catppuccin-mocha)
export LISTMAX=500                  # 清單超過此數才詢問是否顯示

unsetopt menucomplete               # 不自動選中第一個補全項
setopt listambiguous                # 僅在輸入有歧義時顯示選單

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select                         # fzf-tab 移除後改回原生可選單（原為 menu no）
zstyle ':completion:*:messages' format '[%d]'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:options' auto-description '%10d'
zstyle ':completion:*' nospace true                        # 原 fzf-tab path traversal 用；native 下可視需要調整

# 大小寫不敏感 + 模糊比對（. _ - 皆可）
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Carapace 補全引擎（數百個指令的補全來源）
source <(carapace _carapace zsh)

# kill 補全補上 process 名稱（原生選單也適用；原名 _kill_fzf_friendly）
_kill_friendly() {
  local -a pids descriptions
  local pid name
  while read -r pid name; do
    pids+=("$pid")
    descriptions+=("${pid}::${name##*/}")
  done < <(ps -u "$USER" -o pid=,comm= 2>/dev/null | tail -n +2 | head -n 500)
  compadd -d descriptions -a pids
}
compdef _kill_friendly kill
