defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

eval $(/opt/homebrew/bin/brew shellenv)

# ag search and replace
function agr { ag -0 -l "$1" | xargs -0 perl -pi.bak -e "s/$1/$2/g"; }
function rmbak { find . -name "*.bak" -type f -delete; }

#alias vim='/Applications/MacVim.app/Contents/bin/mvim -v'
alias vifm='vifm .'
alias vic="cd ~/vic"
alias dev="cd ~/vic/dev"
alias doc="cd ~/vic/doc"
alias lab="cd ~/vic/lab"
alias old="cd ~/vic/old"
alias pic="cd ~/vic/pic"
alias ppl="cd ~/vic/ppl"
alias sci="cd ~/vic/sci"
alias aud="cd ~/vic/aud"
alias osx="cd ~/vic/osx"
alias vid="cd ~/vic/vid"
alias moo="cd ~/vic/dev/moonad"
alias fmy="cd ~/vic/dev/formality"
alias sys="cd ~/vic/dev/moonad/sys"
alias lib="cd ~/vic/dev/moonad/lib"
alias uwu="cd ~/vic/uwu"

alias ls='ls -GFhla'
alias tree='tree -I node_modules'
alias c='clear'
alias ic='imgcat'
alias ag='ag --ignore "*min.js" --ignore "*node_modules*"'

export BASH_SILENCE_DEPRECATION_WARNING=1

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export LSCOLORS=ExFxBxDxCxegedabagacad
export PS1='%n@%m %~$ '
export CLICOLOR=1

[ -f "/Users/v/.ghcup/env" ] && source "/Users/v/.ghcup/env" # ghcup-env
