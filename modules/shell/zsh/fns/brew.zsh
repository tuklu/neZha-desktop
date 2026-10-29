[[ $OSTYPE == darwin* ]] || return 0

brew-check() { brew update && brew outdated; }
brew-upgrade() { brew update && brew upgrade && brew cleanup; }
