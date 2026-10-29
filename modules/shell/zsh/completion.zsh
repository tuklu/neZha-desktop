[[ -n $HOMEBREW_PREFIX ]] && fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

autoload -Uz compinit
() {
  local dump=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump
  [[ -d ${dump:h} ]] || mkdir -p ${dump:h}
  # The security audit of fpath runs at most daily; -C reuses the dump between.
  local -a stale=($dump(N.mh+24))
  if [[ ! -e $dump ]] || (( $#stale )); then
    compinit -d $dump
  else
    compinit -C -d $dump
  fi
}

# Must follow compinit and precede the plugins that wrap widgets.
plug fzf-tab
