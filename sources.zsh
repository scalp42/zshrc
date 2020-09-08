# pyenv init takes care of that
# $(pyenv root)/completions/pyenv.zsh

# if [[ -f "$(brew --prefix)/opt/mcfly/mcfly.bash" ]]; then
#  source "$(brew --prefix)/opt/mcfly/mcfly.bash"
# fi

if [[ -f "/usr/local/bin/aws_zsh_completer.sh" ]]; then
  source "/usr/local/bin/aws_zsh_completer.sh"
fi
