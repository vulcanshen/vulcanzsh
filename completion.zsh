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
autoload -Uz compinit && compinit
