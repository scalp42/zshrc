# NOTE: quick check for thefuck existence using hash
if (( $+commands[thefuck] )); then
  # NOTE: load thefuck with optimized settings
  zinit ice wait'2' lucid as"program" has"thefuck" \
    atload'
      # NOTE: cache the thefuck alias evaluation
      _thefuck_alias=$(thefuck --alias)
      eval "$_thefuck_alias"
      unset _thefuck_alias

      # NOTE: optimize the correction function
      fuck-command-line() {
        local FUCK
        FUCK=$(THEFUCK_REQUIRE_CONFIRMATION=0 THEFUCK_PRIORITY="git_hook_bypass,git_pull_uncommitted_changes" thefuck "$(fc -ln -1)" 2>/dev/null)
        if [[ -n "$FUCK" ]]; then
          BUFFER="$FUCK"
          zle end-of-line
        fi
      }
      zle -N fuck-command-line

      # NOTE: single bindkey call with multiple modes
      for keymap in emacs vicmd viins; do
        bindkey -M $keymap "\e\e" fuck-command-line
      done
    '
  zinit snippet OMZP::thefuck
# else
#   print -P "%F{yellow}thefuck not found. Install with: brew install thefuck%f"
fi
