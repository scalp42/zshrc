#!/usr/bin/env zsh

export EDITOR=nano
export VISUAL="subl -w -n -- ${@}"
export PAGER=less
# export LESS="-X"
export LANG="en_US.UTF-8"
export LC_ALL=en_US.UTF-8

export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/opt/local/bin:/usr/local/sbin:/Applications/Google\ Chrome.app/Contents/MacOS:$PATH
export PATH=$HOME/go/bin:$PATH

# Don’t clear the screen after quitting a manual page.
export MANPAGER="less -X"

# Simply type the name of a directory, and it will become the current directory
setopt AUTOCD

# Turns on interactive comments, ex: "date # this is a comment"
setopt INTERACTIVECOMMENTS

# Prevents from accidentally overwriting an existing file
setopt NOCLOBBER

# Use a more elegant method for including single quotes in a singly quoted string
setopt RCQUOTES

# Stop zsh from allowing flow control and hence restoring the use of the keys \C-s and \C-q
unsetopt FLOW_CONTROL

export HOMEBREW_NO_ANALYTICS=1

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1;
then
  export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM=xterm-256color
fi

case "$TERM" in
  xterm-*color) color_prompt=yes;;
esac

export BAT_PAGER=""

export TLDR_PARAM='yellow'

export AWS_DEFAULT_REGION="us-west-2"

export AWS_PAGER=

# export PATH="/usr/local/opt/openjdk@11/bin:$PATH"

export PYTHONIOENCODING='UTF-8';

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history;
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768';
# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy';

# see https://stackoverflow.com/questions/39494631/gpg-failed-to-sign-the-data-fatal-failed-to-write-commit-object-git-2-10-0/42265848#42265848
export GPG_TTY=$(tty)

# NOTE: brew install vivid (https://github.com/sharkdp/vivid)
if (( $+commands[vivid] )) export LS_COLORS="$(vivid generate molokai)"

export COMPLETION_WAITING_DOTS=true

if [[ -a "$ZSH_CONF/secrets/exports.zsh" ]]; then
  source "$ZSH_CONF/secrets/exports.zsh"
fi
