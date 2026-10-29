# Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"

extract() {
  (( $# == 1 )) || { print -u2 "Usage: extract <archive>"; return 2; }
  [[ -f $1 ]] || { print -u2 "Not a file: $1"; return 1; }
  case $1 in
    *.tar.bz2|*.tbz2) tar xjf -- "$1" ;;
    *.tar.gz|*.tgz)   tar xzf -- "$1" ;;
    *.tar.xz|*.txz)   tar xJf -- "$1" ;;
    *.tar.zst)        tar --zstd -xf -- "$1" ;;
    *.tar)            tar xf -- "$1" ;;
    *.zip)            unzip -- "$1" ;;
    *.7z)             7z x -- "$1" ;;
    *) print -u2 "Unsupported archive: $1"; return 1 ;;
  esac
}
