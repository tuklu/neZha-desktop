bindkey -v

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

if (( $+widgets[history-substring-search-up] )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
else
  bindkey '^[[A' history-search-backward
  bindkey '^[[B' history-search-forward
fi
