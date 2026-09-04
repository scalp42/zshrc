#!/usr/bin/env zsh

zinit snippet $ZSH_HOME/history.zsh
zinit snippet $ZSH_HOME/alias.zsh
zinit snippet $ZSH_HOME/functions.zsh
zinit snippet $ZSH_HOME/eval.zsh
zinit snippet $ZSH_HOME/completions.zsh
zinit ice compile wait blockf silent; zinit snippet $ZSH_HOME/directories.zsh

# NOTE: `wait'N'` is zinit's turbo mode: the plugin loads N seconds after the first prompt.
# There is no `turbo` ice, an unknown ice word makes zinit drop every ice after it
zinit ice wait'2' lucid; zinit load ChrisPenner/copy-pasta

# NOTE: https://github.com/marzocchi/zsh-notify
# NOTE: brew install terminal-notifier
# NOTE: zsh-notify only supports iTerm2 and Apple Terminal, anywhere else (VS Code, Zed, SSH sessions
# where TERM_PROGRAM is not forwarded, ...) it prints "zsh-notify: unsupported environment" and bails
# out, so we mirror its detection from notify.plugin.zsh and skip loading it instead of blocklisting terminals
if [[ "$TERM_PROGRAM" == "iTerm.app" || "$TERM_PROGRAM" == "Apple_Terminal" || -n "$ITERM_SESSION_ID" || -n "$TERM_SESSION_ID" ]]; then
  zinit ice wait'2' lucid atload'
    zstyle ":notify:*" error-title "Failed (in #{time_elapsed} seconds)"
    zstyle ":notify:*" success-title "Done (in #{time_elapsed} seconds)"
    zstyle ":notify:*" command-complete-timeout 15
    zstyle ":notify:*" blacklist-regex "find|git|cd|l|ll|ls|cat|bat|man|gti|ag|nano|watch"'
  zinit light marzocchi/zsh-notify
fi

# NOTE: speed up completion-related plugin loading by precompiling and blocking functions redefinitions
zinit ice blockf compile lucid; zinit load zsh-users/zsh-completions

# NOTE: initialize the completion system now, so all completion functions are available.
# `-C` skips compaudit's ownership scan of every fpath dir (~20ms per start) and the check for
# new completion functions, the full run still happens once a day, keyed on the dump's mtime
autoload -Uz compinit
() {
  setopt localoptions extendedglob
  if [[ -n "$ZSH_COMPDUMP"(#qN.mh-24) ]]; then
    compinit -C -d "$ZSH_COMPDUMP"
  else
    compinit -d "$ZSH_COMPDUMP"
    touch "$ZSH_COMPDUMP"
  fi
}
zicdreplay -q

# NOTE: fzf-tab must load after compinit, deferred to just after the first prompt
zinit ice wait lucid; zinit load Aloxaf/fzf-tab

# NOTE: https://github.com/zsh-users/zsh-autosuggestions, loaded after fzf-tab as its README asks.
# MANUAL_REBIND skips a per-prompt rebind, so the plugin is started explicitly once loaded
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
zinit ice wait'1' lucid atload'_zsh_autosuggest_start'; zinit light zsh-users/zsh-autosuggestions

zinit ice pick"h.sh" wait'2' lucid; zinit light paoloantinori/hhighlighter

# NOTE: exports.zsh is sourced directly, not as a zinit snippet, so its PATH edits come last
source "$ZSH_HOME/exports.zsh"
