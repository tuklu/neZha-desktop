(( $+commands[starship] )) && eval "$(starship init zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
(( $+commands[fzf] )) && source <(fzf --zsh)
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"
# Generating uv's completion takes ~16ms, so it is cached until uv itself changes.
if (( $+commands[uv] )); then
  uv_completion=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/uv-completion.zsh
  [[ $uv_completion -nt $commands[uv] ]] || uv generate-shell-completion zsh >| $uv_completion
  source $uv_completion
  unset uv_completion
fi
