# Interactive zsh. Order matters: fzf-tab needs compinit, keys binds the
# history-substring-search widgets, and syntax-highlighting wraps every widget
# that exists when it loads, so it goes last.
ZSH_CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/zsh

# Already sourced by ~/.zshenv; again here because macOS path_helper runs in
# between and moves the system paths back in front.
source $ZSH_CONFIG_DIR/env.zsh

# Sources a plugin from wherever the OS package manager put it.
plug() {
  local name=$1 file
  for file in \
    /usr/share/zsh/plugins/$name/$name.plugin.zsh \
    /usr/share/zsh/plugins/$name/$name.zsh \
    ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/$name/$name.zsh} \
    ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/$name/share/$name/$name.zsh}; do
    [[ -r $file ]] && { source $file; return }
  done
}

platform=$ZSH_CONFIG_DIR/platform/${OSTYPE%%[0-9.-]*}.zsh
[[ -r $platform ]] && source $platform
unset platform

for part in options completion tools aliases; do
  source $ZSH_CONFIG_DIR/$part.zsh
done
for fn in $ZSH_CONFIG_DIR/fns/*.zsh(N); do
  source $fn
done
unset part fn

plug zsh-autosuggestions
plug zsh-history-substring-search
source $ZSH_CONFIG_DIR/keys.zsh

# Machine and personal additions, linked in by the private overlay.
for local_file in ${XDG_CONFIG_HOME:-$HOME/.config}/nezha/local/zsh/*.zsh(N); do
  source $local_file
done
unset local_file

plug zsh-syntax-highlighting
