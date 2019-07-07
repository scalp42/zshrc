# eval "$(/Users/scalp/.chefvm/bin/chefvm init -)"

# eval "$(ntfy shell-integration)"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if which pyenv-virtualenv-init > /dev/null; then
  eval "$(pyenv virtualenv-init -)";
fi

if which fuck > /dev/null; then
  eval "$(thefuck --alias)";
fi

if which hub >  /dev/null; then
  eval "$(hub alias -s)"
fi
