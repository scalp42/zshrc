#!/usr/bin/env zsh

# NOTE: uncomment to profile
# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH_CONF=$HOME/.zsh
export ZSH_CACHE=$ZSH_CONF/cache
export ZSH_CACHE_DIR=$ZSH_CACHE
export ZSH_COMPDUMP="${ZSH_CACHE}/.zcompdump-${(%):-%m}-${ZSH_VERSION}"
export ZSH_EVALCACHE_DIR=$ZSH_CACHE

# NOTE: pick your poison 👨‍🔬
source $ZSH_CONF/zinit.zsh
# source $ZSH_CONF/zgen.zsh

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# NOTE: uncomment to profile
# zprof
