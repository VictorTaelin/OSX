defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

eval $(/opt/homebrew/bin/brew shellenv)

export PATH="/opt/homebrew/opt/python@3.10/bin:$PATH"

export DENO_INSTALL="/Users/v/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

function agr { ag -0 -l "$1" | xargs -0 perl -pi.bak -e "s/$1/$2/g"; }
function rmbak { find . -name "*.bak" -type f -delete; }
function clo0 { java -jar /Users/v/vic/dev/closure-compiler/closure-compiler-v20210406.jar --process_common_js_modules --module_resolution NODE --compilation_level BUNDLE --language_in ECMASCRIPT_2020 --js "$1" --js_output_file "$2" }
function clo1 { java -jar /Users/v/vic/dev/closure-compiler/closure-compiler-v20210406.jar --process_common_js_modules --module_resolution NODE --compilation_level WHITESPACE_ONLY --language_in ECMASCRIPT_2020 --js "$1" --js_output_file "$2" }
function clo2 { java -jar /Users/v/vic/dev/closure-compiler/closure-compiler-v20210406.jar --process_common_js_modules --module_resolution NODE --compilation_level SIMPLE --language_in ECMASCRIPT_2020 --js "$1" --js_output_file "$2" }
function clo3 { java -jar /Users/v/vic/dev/closure-compiler/closure-compiler-v20210406.jar --process_common_js_modules --module_resolution NODE --compilation_level ADVANCED --language_in ECMASCRIPT_2020 --language_out ECMASCRIPT_2020 --js "$1" --js_output_file "$2" }
function kjs { rm "$2"; kind "$1" --js | js-beautify >> "$2" }

#alias vim='/Applications/MacVim.app/Contents/bin/mvim -v'
alias vifm='vifm .'
alias vic="cd ~/vic"
alias dev="cd ~/vic/dev"
alias doc="cd ~/vic/doc"
alias img="cd ~/vic/img"
alias osx="cd ~/vic/osx"
alias pvt="cd ~/vic/pvt"
alias vid="cd ~/vic/vid"
alias con="vim ~/vic/doc/contra.txt"
alias pass="vim ~/vic/pvt/pass.pvt"

alias ls='ls -GFhla'
alias tree='tree -I node_modules'
alias c='clear'
alias ic='imgcat'
alias ag='ag --ignore "*min.js" --ignore "*node_modules*"'

export BASH_SILENCE_DEPRECATION_WARNING=1

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export LSCOLORS=ExFxBxDxCxegedabagacad
export PS1='%n@%m %~$ ' # if this stops working, edit /etc/zshrc
export CLICOLOR=1

[ -f "/Users/v/.ghcup/env" ] && source "/Users/v/.ghcup/env" # ghcup-env
