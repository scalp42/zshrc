#!/usr/bin/env zsh

# NOTE: uncomment to profile
# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# export PATH=/usr/local/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/opt/local/bin:/usr/local/sbin:/Applications/Google\ Chrome.app/Contents/MacOS:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
# export PATH=$HOME/go/bin:$PATH

export ZSH_CONF=$HOME/.zsh
export ZSH_CACHE=$ZSH_CONF/cache
export ZSH_CACHE_DIR=$ZSH_CACHE
export ZSH_COMPDUMP="${ZSH_CACHE}/.zcompdump-${(%):-%m}-${ZSH_VERSION}"

# NOTE: pick your poison 👨‍🔬
source $ZSH_CONF/zinit.zsh
# source $ZSH_CONF/zgen.zsh

source $ZSH_CONF/ls_colors.zsh

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# NOTE: uncomment to profile
# zprof

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
