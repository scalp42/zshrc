#!/usr/bin/env zsh

# eval "$(starship init zsh)"

if [[ -a "$ZSH_CONF/secrets/eval.zsh" ]]; then
  source "$ZSH_CONF/secrets/eval.zsh"
fi

# NOTE: https://github.com/ajeetdsouza/zoxide
# if (( ${+commands[zoxide]} )) eval "$(zoxide init zsh)"

# NOTE: https://github.com/gsamokovarov/jump
eval "$(jump shell)"
