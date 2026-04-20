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

