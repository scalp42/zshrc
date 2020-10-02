#!/usr/bin/env zsh

# NOTE: see https://www.iterm2.com/documentation-shell-integration.html
# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


if [[ -a "/usr/local/bin/aws_zsh_completer.sh" ]]; then
  source "/usr/local/bin/aws_zsh_completer.sh"
fi
