defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

alias vim='/Applications/MacVim.app/Contents/bin/mvim -v'

function base() {
  scp fpm:~/formality-package-manager/fm/Base#$1.fm .
  scp Base#$1.fm fpm:~/formality-package-manager/fm/Base#.fm
}

export LSCOLORS=ExFxBxDxCxegedabagacad
export PS1='\[\033[00;34m\]\w\[\033[00m\]: '
export CLICOLOR=1

alias ls='ls -GFhla'
alias tree='tree -I node_modules'
alias c='clear'
alias ic='imgcat'
alias ag='ag --ignore "*min.js" --ignore "*node_modules*"'

export PATH="$HOME/.cargo/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /Users/v/.ghcup/env

export BASH_SILENCE_DEPRECATION_WARNING=1
