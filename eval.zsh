# NOTE: `brew shellenv` only produces these constants on Apple Silicon, exporting them
# statically saves a ~9ms fork on every shell start. PATH is built in exports.zsh, and the
# site-functions dir is already in zsh's compiled-in fpath (`typeset -U fpath` in .zshrc
# drops the duplicate)
if [[ -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  # NOTE: guarded so nested shells don't prepend the same entry again
  [[ ":${INFOPATH:-}:" == *:/opt/homebrew/share/info:* ]] || export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
  fpath=("/opt/homebrew/share/zsh/site-functions" $fpath)
  # NOTE: a leading ":" tells man to search its default paths too, mirrors `brew shellenv`
  [[ -z "${MANPATH-}" ]] || export MANPATH=":${MANPATH#:}"
fi

# NOTE: the blocks below cache each tool's init script via cache_init (functions.zsh), which
# regenerates the cache whenever the tool's binary is newer than it

# NOTE: https://starship.rs
if (( ${+commands[starship]} )); then
  cache_init starship "${commands[starship]}" starship init zsh
fi

# NOTE: https://github.com/gsamokovarov/jump
if (( ${+commands[jump]} )); then
  cache_init jump "${commands[jump]}" jump shell zsh
fi

# NOTE: https://github.com/junegunn/fzf#setting-up-shell-integration
if (( ${+commands[fzf]} )); then
  cache_init fzf "${commands[fzf]}" fzf --zsh
fi

# NOTE: Ctrl-R keeps every command in the history file but hides navigation noise from the
# search list. fzf's widget builds that list with `fc -rl 1`, so it is renamed and called with a
# temporary fc function that filters its output. The original widget is untouched, fzf upgrades
# keep working as long as the widget still calls fc
if (( ${+functions[fzf-history-widget]} )); then
  functions -c fzf-history-widget _fzf_history_widget_unfiltered
  fzf-history-widget() {
    fc() {
      builtin fc "$@" | grep -vE '^ *[0-9]+\*? +(ls|ll|la|l|cd|pwd|clear|exit|xi|history|bg|fg|date)( .*)?$|^ *[0-9]+\*? +man |^ *[0-9]+\*? +.* --help$'
    }
    _fzf_history_widget_unfiltered
    unfunction fc
  }
  zle -N fzf-history-widget
fi

# NOTE: secrets evals
if [[ -f "$ZSH_HOME/secrets/eval.zsh" ]]; then
  source "$ZSH_HOME/secrets/eval.zsh"
fi
