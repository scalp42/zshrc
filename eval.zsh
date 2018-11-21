eval "$(/Users/$(whoami)/.chefvm/bin/chefvm init -)"

# eval "$(ntfy shell-integration)"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if which pyenv-virtualenv-init > /dev/null; then
  eval "$(pyenv virtualenv-init -)";
fi
