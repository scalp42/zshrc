#!/usr/bin/env zsh

zinit snippet $ZSH_HOME/history.zsh
zinit snippet $ZSH_HOME/alias.zsh
zinit snippet $ZSH_HOME/functions.zsh
zinit snippet $ZSH_HOME/eval.zsh
zinit snippet $ZSH_HOME/completions.zsh
zinit ice compile wait blockf silent; zinit snippet $ZSH_HOME/directories.zsh

# NOTE: `wait'N'` is zinit's turbo mode: the plugin loads N seconds after the first prompt
# (there is no `turbo` ice, an unknown ice word makes zinit drop every ice after it)
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

# NOTE: initialize the completion system now, so all completion functions are available, with
# `-C` skipping compaudit's ownership scan of every fpath dir (~20ms per start) and the check for
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

# NOTE: Tab accepts the grey autosuggestion ($POSTDISPLAY) when the cursor sits at the end of
# the line and the completed line is an exact history entry, otherwise it falls through to
# fzf-tab. The completion strategy also fills the grey text, with the first candidate of the
# very menu fzf-tab would show, so accepting every suggestion would hide the menu on nearly
# every Tab. autosuggest-accept itself ignores a cursor that is not at the end, which would
# turn Tab into a dead key. Shift+Tab always opens fzf-tab
tab-accept-or-complete() {
  if [[ -n "$POSTDISPLAY" ]] && (( CURSOR == $#BUFFER )) \
      && [[ -n "${history[(re)${BUFFER}${POSTDISPLAY}]}" ]]; then
    zle autosuggest-accept
  else
    zle fzf-tab-complete
  fi
}
zle -N tab-accept-or-complete

# NOTE: fzf-tab must load after compinit, deferred to just after the first prompt. Our Tab
# widget is bound in atload because fzf-tab binds ^I itself on load, in the same two keymaps
zinit ice wait lucid atload'bindkey -M emacs "^I" tab-accept-or-complete; bindkey -M viins "^I" tab-accept-or-complete; bindkey -M emacs "^[[Z" fzf-tab-complete; bindkey -M viins "^[[Z" fzf-tab-complete'
zinit load Aloxaf/fzf-tab

# NOTE: https://github.com/zsh-users/zsh-autosuggestions, loaded after fzf-tab as its README asks,
# with MANUAL_REBIND skipping a per-prompt rebind, so the plugin is started explicitly once loaded
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# NOTE: The plugin wraps every unlisted widget as a "modify" widget, which empties $POSTDISPLAY
# before the wrapped widget runs, so our Tab widget is added to the ignore list to stay
# unwrapped. Appended in atload so the plugin's own default entries stay in place
zinit ice wait'1' lucid atload'ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(tab-accept-or-complete); _zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice pick"h.sh" wait'2' lucid; zinit light paoloantinori/hhighlighter

# NOTE: exports.zsh is sourced directly, not as a zinit snippet, so its PATH edits come last
source "$ZSH_HOME/exports.zsh"
