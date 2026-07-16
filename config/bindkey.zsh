# vi 模式（zsh 慣用寫法；須在下方自訂 bindkey 之前，綁定才會落在 viins keymap）
bindkey -v

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[k' up-line-or-beginning-search
bindkey '^[j' down-line-or-beginning-search

bindkey '^[h' vi-backward-word
bindkey '^[l' vi-forward-word
bindkey '^[o' autosuggest-accept

zmodload zsh/complist

bindkey -M menuselect '^[k' up-line-or-history
bindkey -M menuselect '^[j' down-line-or-history

