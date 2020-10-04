#!/usr/bin/env zsh

# eval "$(starship init zsh)"

if [[ -a "$ZSH_CONF/secrets/eval.zsh" ]]; then
  source "$ZSH_CONF/secrets/eval.zsh"
fi

# NOTE: https://github.com/ajeetdsouza/zoxide
# if (( ${+commands[zoxide]} )) eval "$(zoxide init zsh)"

eval "$(jump shell)"
