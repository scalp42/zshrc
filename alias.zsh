# NOTE: enable command-line completion for aliases
setopt complete_aliases

# NOTE: remove oh-my-zsh directories lib aliases
unalias l lsa ll la 2>/dev/null

# NOTE: brew install eza
alias ll='eza --classify --long --binary --group --git'
alias la='eza --classify --long --binary --group --git --all'
alias tree='eza --classify --long --binary --group --tree --git'
alias lsr='eza --classify --across --git --recurse'
alias llr='eza --classify --long --binary --group --git --recurse'
alias lar='eza --classify --long --binary --group --git --all --recurse'
alias ltr='eza --classify --long --binary --group --git --reverse --sort modified'
alias ltra='eza --classify --long --binary --group --git --reverse --sort modified --all'

alias xi='exit'
alias htop='sudo htop'
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; mas upgrade'
alias upgrade=update
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"
alias flush="sudo killall -HUP mDNSResponder"
alias sniff="sudo ngrep -d 'en0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en0 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""type -t md5sum > /dev/null || alias md5sum="md5"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias killosx='echo "Kill affected applications" ; for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done'
alias stoptime='sudo tmutil disablelocal'
alias starttime='sudo tmutil enablelocal'
alias gti=git
alias gi=git
alias ogc='open -a Google\ Chrome --args --disable-web-security'
alias pipu='pip3 freeze | xargs pip install --upgrade'
alias rmv='rvm use 2.7.1 --install --create'
alias dockerinit='eval "$(docker-machine env default)"; export DOCKER_IP=$(docker-machine ip default)'
alias cat='bat -pP'
alias sssh='ssh -v -o ConnectTimeout=3 -o ConnectionAttempts=999'
alias week='date +%V'
alias path='echo -e ${PATH//:/\\n}'
alias stt='subl .'
alias sttt='subl -a .'

# NOTE: https://github.com/kaelzhang/shell-safe-rm
alias rm='safe-rm'

# NOTE: if pbzip2/pigz are available, alias them as they are drop-in replacements for bzip2/gzip, respectively
if (( ${+commands[pbzip2]} )) alias bzip2='pbzip2'
if (( ${+commands[pbunzip2]} )) alias bunzip2='pbunzip2'
if (( ${+commands[pigz]} )) alias gzip='pigz'
if (( ${+commands[unpigz]} )) alias gunzip='unpigz'

alias zupdate='zi update -r --all -p 20'
alias zclean='zi delete --clean'

alias nnao="nano "

# NOTE: VSCode aliases/functions
vscode_path="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
if [[ -x "$vscode_path" ]]; then
  function co() {
    "$vscode_path" .
  }
  function coo() {
    "$vscode_path" -r .
  }
else
  function co() {
    echo 'VSCode not installed or not in PATH. Install VSCode and run: Install "code" command in PATH.'
  }
  function coo() {
    echo 'VSCode not installed or not in PATH. Install VSCode and run: Install "code" command in PATH.'
  }
fi

alias backup_zsh='backup_zsh_function'

if [[ -a "$ZSH_HOME/secrets/alias.zsh" ]]; then
  source "$ZSH_HOME/secrets/alias.zsh"
fi
