HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
HISTSIZE=50000
SAVEHIST=50000
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}

# Fold history from the old locations (Linux default, previous macOS setup) into
# this one. The symlink keeps shells still running with the old HISTFILE
# writing into the same file.
for old_history in ~/.zsh_history ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/history; do
  [[ -f $old_history && ! -L $old_history ]] || continue
  cat $old_history >> $HISTFILE && rm $old_history && ln -s $HISTFILE $old_history
done
unset old_history

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt INTERACTIVE_COMMENTS

unsetopt HASH_CMDS
setopt MARK_DIRS
setopt AUTO_MENU
setopt AUTO_LIST
setopt COMPLETE_IN_WORD
unsetopt GLOB_DOTS
