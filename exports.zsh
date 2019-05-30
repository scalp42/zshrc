export EDITOR=nano
export VISUAL=subl
export PAGER=less
# export LESS="-X"
export LANG="en_US.UTF-8"
export LC_ALL=en_US.UTF-8

export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/opt/local/bin:/usr/local/sbin:/Applications/Google\ Chrome.app/Contents/MacOS:$PATH
export PATH=$HOME/go/bin:$PATH

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

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
export PACKER_TIMESTAMP=$(timestamp)

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

export THEFUCK_REQUIRE_CONFIRMATION='false'
