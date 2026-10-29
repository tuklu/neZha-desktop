# Create a Tmux Dev Layout with editor, ai, and terminal
tdl() {
  [[ -z $1 ]] && { echo "Usage: tdl <c|cx|codex|other_ai> [<second_ai>]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }

  local current_dir="${PWD}"
  local editor_pane ai_pane ai2_pane
  local ai="$1"
  local ai2="$2"

  editor_pane="$TMUX_PANE"
  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi

  tmux send-keys -t "$ai_pane" "$ai" C-m
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
  tmux select-pane -t "$editor_pane"
}

# Create multiple tdl windows with one per subdirectory
tdlm() {
  [[ -z $1 ]] && { echo "Usage: tdlm <c|cx|codex|other_ai> [<second_ai>]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdlm."; return 1; }

  local ai="$1"
  local ai2="$2"
  local base_dir="$PWD"
  local first=true

  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

  # Zsh specific directory globbing
  for dir in "$base_dir"/*(/N); do
    local dirpath="${dir%/}"

    if $first; then
      tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tdl $ai $ai2" C-m
      first=false
    else
      local pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
    fi
  done
}

# Create a multi-pane swarm layout
tsl() {
  [[ -z $1 || -z $2 ]] && { echo "Usage: tsl <pane_count> <command>"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tsl."; return 1; }

  local count="$1"
  local cmd="$2"
  local current_dir="${PWD}"
  local -a panes

  tmux rename-window -t "$TMUX_PANE" "$(basename "$current_dir")"
  panes+=("$TMUX_PANE")

  while (( ${#panes[@]} < count )); do
    local new_pane
    local split_target="${panes[-1]}"
    new_pane=$(tmux split-window -h -t "$split_target" -c "$current_dir" -P -F '#{pane_id}')
    panes+=("$new_pane")
    
    # Zsh array index starts at 1, not 0
    tmux select-layout -t "${panes[1]}" tiled
  done

  for pane in "${panes[@]}"; do
    tmux send-keys -t "$pane" "$cmd" C-m
  done

  # Zsh array index starts at 1
  tmux select-pane -t "${panes[1]}"
}

#status-bar
precmd() {
  print -Pn "\e]0;%m\a"
}
