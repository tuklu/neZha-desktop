mkcd() {
  (( $# == 1 )) || { print -u2 "Usage: mkcd <directory>"; return 2; }
  mkdir -p -- "$1" && builtin cd -- "$1"
}
