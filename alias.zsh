#!/usr/bin/env zsh

alias ll='ls -lFh --color'
alias la='ls -lFha --color'
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
alias ogc='open -a Google\ Chrome --args --disable-web-security'
alias pipu='pip3 freeze | xargs pip install --upgrade'
alias rmv='rvm use 2.7.1 --install --create'
alias chefdk='eval "$(chef shell-init $PYENV_SHELL)"'
alias dockerinit='eval "$(docker-machine env default)"; export DOCKER_IP=$(docker-machine ip default)'
alias cat='bat -nP'
alias sssh='ssh -v -o ConnectTimeout=3 -o ConnectionAttempts=999'
alias week='date +%V'
alias path='echo -e ${PATH//:/\\n}'
alias sttt='subl -a .'

# NOTE: https://github.com/kaelzhang/shell-safe-rm
alias rm='safe-rm'

# NOTE: if pbzip2/pigz are available, alias them as they are drop-in replacements for bzip2/gzip, respectively
if (( ${+commands[pbzip2]} )) alias bzip2='pbzip2'
if (( ${+commands[pbunzip2]} )) alias bunzip2='pbunzip2'
if (( ${+commands[pigz]} )) alias gzip='pigz'
if (( ${+commands[unpigz]} )) alias gunzip='unpigz'

if [[ -a "$ZSH_CONF/secrets/alias.zsh" ]]; then
  source "$ZSH_CONF/secrets/alias.zsh"
fi
