# 載入順序：config（基礎設定）→ functions（獨立函式）→ modules（強化模組）
# .local/ 是外層結構的鏡子（私人設定，不進版控），各層接在同名的外層之後載入。
# modules/fzf-tab-enhancement.zsh 目前停用（見該檔開頭），故排除。
for f in \
  ${0:h}/config/*.zsh(N.) \
  ${0:h}/.local/config/*.zsh(N.) \
  ${0:h}/functions/*.zsh(N.) \
  ${0:h}/.local/functions/*.zsh(N.) \
  ${0:h}/modules/*.zsh(N.) \
  ${0:h}/.local/modules/*.zsh(N.); do
  [[ "${f:t}" != "fzf-tab-enhancement.zsh" ]] && source "$f"
done
