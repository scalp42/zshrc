#!/usr/bin/env zsh

# eval "$(starship init zsh)"

if [[ -a "$ZSH_CONF/secrets/eval.zsh" ]]; then
  source "$ZSH_CONF/secrets/eval.zsh"
fi
