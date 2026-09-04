#!/usr/bin/env zsh

zinit snippet $ZSH_HOME/history.zsh
zinit snippet $ZSH_HOME/alias.zsh
zinit snippet $ZSH_HOME/functions.zsh
zinit snippet $ZSH_HOME/eval.zsh
zinit snippet $ZSH_HOME/completions.zsh
zinit ice compile wait blockf silent; zinit snippet $ZSH_HOME/directories.zsh

# TODO: optimize more if possible
zinit ice wait'2' lucid; zinit snippet $ZSH_HOME/fuck.zsh

# NOTE: load plugins that don't depend on completion first
# TODO: busted with asdf move to Go
# zinit load asdf-vm/asdf

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

# NOTE: Defer loading of git-ignore until after the second prompt redraw
# TODO: seems to hijack PATH?
# further deferring non-essential functionality until after the shell is ready
# zinit ice wait'2' lucid; zinit load laggardkernel/git-ignore

zinit ice pick"h.sh" wait'2' lucid; zinit light paoloantinori/hhighlighter

# NOTE: source exports.zsh last so that its PATH modifications take precedence
# NOTE: `compile` = precompiles exports file to speed up subsequent shell starts
# NOTE: `wait` = defers loading slightly so it doesn’t slow down initial prompt display
# NOTE: `blockf` = block function redefinitions for speed
# NOTE: `silent` = supress verbose output
# TODO: debug why it's not working
# zinit ice compile blockf silent
# zinit snippet $ZSH_HOME/exports.zsh
# zinit ice atload'export PATH="$HOME/.asdf/shims:$PATH"' compile blockf silent
# zinit snippet "$ZSH_HOME/exports.zsh"
source "$ZSH_HOME/exports.zsh"
