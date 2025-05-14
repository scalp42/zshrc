#!/usr/bin/env zsh

zinit snippet $ZSH_HOME/history.zsh
zinit snippet $ZSH_HOME/alias.zsh
zinit snippet $ZSH_HOME/functions.zsh
zinit snippet $ZSH_HOME/eval.zsh
zinit ice compile wait blockf silent; zinit snippet $ZSH_HOME/directories.zsh

# TODO: optimize as it's slow
# zinit ice compile blockf silent; zinit snippet $ZSH_HOME/completions.zsh
# zinit ice blockf silent; zinit snippet $ZSH_HOME/completions.zsh

# TODO: optimize more if possible
zinit ice wait'2' lucid; zinit snippet $ZSH_HOME/fuck.zsh

# NOTE: load plugins that don't depend on completion first
# TODO: busted with asdf move to Go
# zinit load asdf-vm/asdf

zinit ice turbo'2' wait lucid; zinit load ChrisPenner/copy-pasta

# NOTE: https://github.com/marzocchi/zsh-notify
# NOTE: brew install terminal-notifier
# NOTE: only load zsh-notify if not in VS Code terminal to work around "zsh-notify: unsupported environment"
if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  zinit ice wait'2' lucid atload'
    zstyle ":notify:*" error-title "Failed (in #{time_elapsed} seconds)"
    zstyle ":notify:*" success-title "Done (in #{time_elapsed} seconds)"
    zstyle ":notify:*" command-complete-timeout 15
    zstyle ":notify:*" enable-on-ssh yes
    zstyle ":notify:*" blacklist-regex "find|git|cd|l|ll|ls|cat|bat|man|gti|ag|nano|watch"'
  zinit light marzocchi/zsh-notify
fi

# NOTE: speed up completion-related plugin loading by precompiling and blocking functions redefinitions
zinit ice blockf compile lucid; zinit load zsh-users/zsh-completions

# NOTE: initialize the completion system now, so all completion functions are available
autoload -Uz compinit
compinit -d $ZSH_COMPDUMP
zicdreplay -q

# NOTE: Defer loading of fzf-tab by 1 second after prompt display (for a snappier startup)
# 'turbo' loads the plugin after 1 second of displaying the prompt
zinit ice turbo'2' wait lucid; zinit load Aloxaf/fzf-tab

# NOTE: Defer loading of git-ignore until after the second prompt redraw
# TODO: seems to hijack PATH?
# further deferring non-essential functionality until after the shell is ready
# zinit ice wait'2' lucid; zinit load laggardkernel/git-ignore

zinit ice pick"h.sh" turbo"2" lucid; zinit light paoloantinori/hhighlighter

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
