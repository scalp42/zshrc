#!/usr/bin/env zsh

ZGEN_HOME=~/.zgen

. /usr/local/opt/asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

ZSH_AUTOLOAD=${ZSH_CONF}/autoload
fpath+="${ZSH_AUTOLOAD}"
if [[ -d "$ZSH_AUTOLOAD" ]]; then
    for func in $ZSH_AUTOLOAD/*; do
        autoload -Uz ${func:t}
    done
fi
unset ZSH_AUTOLOAD

autoload -Uz compinit && \
   compinit -C -d $ZSH_COMPDUMP


if [[ ! -f $ZGEN_HOME/zgen.zsh ]]; then
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
  echo "Initializing..."

  zgen load romkatv/powerlevel10k powerlevel10k
  zgen load unixorn/fzf-zsh-plugin
  zgen oh-my-zsh plugins/cp

  # NOTE: opens in current window instead of new one
  # zgen load valentinocossar/sublime
  zgen oh-my-zsh plugins/sublime

  zgen oh-my-zsh plugins/fd
  zgen oh-my-zsh plugins/encode64
  zgen load djui/alias-tips
  zgen oh-my-zsh plugins/colored-man-pages
  zgen oh-my-zsh plugins/safe-paste
  zgen load unixorn/git-extra-commands
  zgen oh-my-zsh plugins/urltools
  zgen load tj/git-extras

  # NOTE: https://github.com/zsh-users/zsh-autosuggestions
  # zgen load zsh-users/zsh-autosuggestions

  # NOTE: a bit slow
  # zgen load unixorn/autoupdate-zgen

  # NOTE: https://github.com/qoomon/zsh-lazyload
  zgen load qoomon/zsh-lazyload

  # NOTE: https://github.com/paoloantinori/hhighlighter
  zgen load paoloantinori/hhighlighter

  # NOTE: https://github.com/hlissner/zsh-autopair
  zgen load hlissner/zsh-autopair

  # NOTE: https://github.com/marzocchi/zsh-notify
  # NOTE: brew install terminal-notifier
  zgen load marzocchi/zsh-notify

  zgen oh-my-zsh plugins/tmux

  # NOTE: https://github.com/mroth/evalcache (vs zsh-lazyload)
  # zgen load mroth/evalcache

  # NOTE: https://github.com/rtuin/zsh-case
  zgen load rtuin/zsh-case

  # NOTE: https://github.com/ChrisPenner/copy-pasta
  zgen load ChrisPenner/copy-pasta

  # NOTE: https://github.com/peterhurford/git-it-on.zsh
  zgen load peterhurford/git-it-on.zsh

  # NOTE: https://github.com/caarlos0-graveyard/zsh-git-sync
  zgen load caarlos0-graveyard/zsh-git-sync

  # NOTE: https://github.com/axtl/gpg-agent.zsh
  # zgen load axtl/gpg-agent.zsh

  # NOTE: https://github.com/rummik/zsh-ing
  zgen load rummik/zsh-ing

  # NOTE: https://github.com/supercrabtree/k
  # zgen load supercrabtree/k

  # NOTE: https://github.com/mdumitru/last-working-dir
  zgen load mdumitru/last-working-dir

  # NOTE: https://github.com/robertzk/send.zsh
  zgen load robertzk/send.zsh

  # NOTE: load last
  zgen load zdharma/fast-syntax-highlighting

  zgen save
fi

source $ZSH_CONF/directories.zsh
source $ZSH_CONF/history.zsh
source $ZSH_CONF/functions.zsh
source $ZSH_CONF/alias.zsh
source $ZSH_CONF/exports.zsh
source $ZSH_CONF/sources.zsh
source $ZSH_CONF/eval.zsh
source $ZSH_CONF/completions.zsh
source $ZSH_CONF/fuck.zsh
source $ZSH_CONF/termsupport.zsh
source $ZSH_CONF/compfix.zsh
