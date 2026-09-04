#!/usr/bin/env zsh

export ZSH_HOME=${HOME}/.zsh
export ZSH_CACHE="${ZSH_HOME}/cache"
export ZSH_COMPDUMP="${ZSH_CACHE}/.zcompdump-${(%):-%m}-${ZSH_VERSION}"

# NOTE: zinit routine
export ZINIT_HOME="${HOME}/.zinit"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# NOTE: load custom zinit config
source $ZSH_HOME/zinit.zsh
alias google-chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

# keep: menu bar mouse jiggler (~/projs/keep). Starts it detached; no-op if already running.
unalias keepbar 2>/dev/null  # older shells may still hold the foreground alias
keepbar() {
  local label="com.scalp.keep" plist="$HOME/Library/LaunchAgents/com.scalp.keep.plist"
  if launchctl print "gui/$(id -u)/$label" >/dev/null 2>&1; then
    if launchctl print "gui/$(id -u)/$label" | grep -qE "state.=.running"; then
      echo "keep is already running (check the menu bar)."
    else
      launchctl kickstart "gui/$(id -u)/$label" && echo "keep started."
    fi
  elif [ -f "$plist" ]; then
    launchctl bootstrap "gui/$(id -u)" "$plist" && echo "keep started."
  else
    nohup ~/projs/keep/.venv/bin/python3 ~/projs/keep/keep_menubar.py >>"$HOME/Library/Logs/keep.log" 2>&1 &!
    echo "keep started (no LaunchAgent installed; use 'Start at login' in its menu to add one)."
  fi
}
