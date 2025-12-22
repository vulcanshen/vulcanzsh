autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^K' up-line-or-beginning-search
bindkey '^J' down-line-or-beginning-search

bindkey '^H' vi-backward-word
bindkey '^L' vi-forward-word
bindkey '^O' autosuggest-accept
