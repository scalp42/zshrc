#!/usr/bin/env zsh

export ZSH_HOME=${HOME}/.zsh
export ZSH_CACHE="${ZSH_HOME}/cache"
export ZSH_COMPDUMP="${ZSH_CACHE}/.zcompdump-${(%):-%m}-${ZSH_VERSION}"

# NOTE: zinit routine
export ZINIT_HOME="${HOME}/.zinit"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# NOTE: load custom zinit config
source $ZSH_HOME/zinit.zsh
