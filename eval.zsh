# NOTE: if Homebrew is installed, run its shellenv first
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# NOTE: https://starship.rs
if [[ -x "/opt/homebrew/bin/starship" ]]; then
  if [[ ! -f "$ZSH_CACHE/starship.zsh" ]]; then
    starship init zsh > "$ZSH_CACHE/starship.zsh"
  fi
  compile_and_source "$ZSH_CACHE/starship.zsh"
fi

# NOTE: https://github.com/gsamokovarov/jump
if (( ${+commands[jump]} )); then
  if [[ ! -f "$ZSH_CACHE/jump.zsh" ]]; then
    jump shell > "$ZSH_CACHE/jump.zsh"
  fi
  compile_and_source "$ZSH_CACHE/jump.zsh"
fi

# NOTE: https://github.com/trobrock/chefvm
if [[ -x "$HOME/.chefvm/bin/chefvm" ]]; then
  if [[ ! -f "$ZSH_CACHE/chefvm.zsh" ]]; then
    $HOME/.chefvm/bin/chefvm init - > "$ZSH_CACHE/chefvm.zsh"
  fi
  compile_and_source "$ZSH_CACHE/chefvm.zsh"
fi

# NOTE: https://ngrok.com
if [[ -x "/opt/homebrew/bin/ngrok" ]]; then
  if [[ ! -f "$ZSH_CACHE/ngrok.zsh" ]]; then
    ngrok completion > "$ZSH_CACHE/ngrok.zsh"
  fi
  compile_and_source "$ZSH_CACHE/ngrok.zsh"
fi

# NOTE: secrets evals
if [[ -f "$ZSH_HOME/secrets/eval.zsh" ]]; then
  source "$ZSH_HOME/secrets/eval.zsh"
fi
