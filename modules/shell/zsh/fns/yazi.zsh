# Yazi: quit with q to land the shell in yazi's last directory, Q to stay put
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n $cwd && $cwd != "$PWD" ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
