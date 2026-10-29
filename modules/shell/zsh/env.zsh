# Environment for every zsh, scripts included, so it spawns nothing.

typeset -U path PATH

if [[ $OSTYPE == darwin* ]]; then
  for brew_prefix in /opt/homebrew /usr/local; do
    if [[ -x $brew_prefix/bin/brew ]]; then
      export HOMEBREW_PREFIX=$brew_prefix
      path=($brew_prefix/bin $brew_prefix/sbin $path)
      break
    fi
  done
  unset brew_prefix
fi

# Prepended in reverse, so ~/.local/bin ends up first.
for dir in ~/.local/share/nezha/bin ~/.local/bin; do
  [[ -d $dir ]] && path=($dir $path)
done
for dir in ~/go/bin ~/.cargo/bin; do
  [[ -d $dir ]] && path+=($dir)
done
unset dir
export PATH

if (( $+commands[nvim] )); then
  export EDITOR=${EDITOR:-nvim}
else
  export EDITOR=${EDITOR:-vi}
fi
export VISUAL=${VISUAL:-$EDITOR}
export SUDO_EDITOR=$EDITOR
export BAT_THEME=ansi
