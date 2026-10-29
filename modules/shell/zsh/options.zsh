HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
HISTSIZE=50000
SAVEHIST=50000
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}

# One-time move from the old location. The symlink keeps shells that are
# still running with the old HISTFILE writing into the same file.
if [[ ! -e $HISTFILE && -f ~/.zsh_history && ! -L ~/.zsh_history ]]; then
  mv ~/.zsh_history $HISTFILE && ln -s $HISTFILE ~/.zsh_history
fi

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
