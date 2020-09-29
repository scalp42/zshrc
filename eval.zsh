# eval "$(/Users/scalp/.chefvm/bin/chefvm init -)"

# eval "$(ntfy shell-integration)"

# NOTE: oh-my-zsh pyenv plugin takes care of that
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi

# NOTE: oh-my-zsh pyenv plugin takes care of that
# if which pyenv-virtualenv-init > /dev/null; then
#   eval "$(pyenv virtualenv-init -)";
# fi

# if which hub > /dev/null; then
#   eval "$(hub alias -s)"
# fi

# if which aws-vault > /dev/null; then
#   eval "$(aws-vault --completion-script-zsh)"
# fi

# eval "$(starship init zsh)"

test -e "$ZSH_CONF/secrets/eval.zsh" && source $ZSH_CONF/secrets/eval.zsh
