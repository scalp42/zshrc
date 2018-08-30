# Share history between multiple shells
setopt SHARE_HISTORY

# Allow multiple terminal sessions to all append to one zsh command history
setopt APPEND_HISTORY

# Save the time and how long a command ran
setopt EXTENDED_HISTORY

# Do not write events to history that are duplicates of the immediately previous event
setopt HIST_IGNORE_DUPS

# Even if there are commands in-between commands that are the same, still only save the last one
setopt HIST_IGNORE_ALL_DUPS

# Remove extra blanks from each command line being added to history
setopt HIST_REDUCE_BLANKS

# If a line starts with a space, don't save it.
setopt HIST_IGNORE_SPACE

# When using a hist thing, make a newline show the change before executing it.
setopt HIST_VERIFY

# Allows history references to clobber files even when CLOBBER is unset.
setopt HIST_ALLOW_CLOBBER

# Don't store history (fc -l) command
setopt HIST_NO_STORE

# Don't store function definitions
setopt HIST_NO_FUNCTIONS

# Ignores duplicates when writing history file
setopt HIST_SAVE_NO_DUPS

# Start removing repeating commands when limit of $HISTSIZE is reached
setopt HIST_EXPIRE_DUPS_FIRST

# Do not display a line previously found
setopt HIST_FIND_NO_DUPS

# Treat the '!' character specially during expansion
setopt BANG_HIST


HISTSIZE=1000000
SAVEHIST=1000000

HISTIGNORE="ll:ls:history:[bf]g:exit:pwd:clear:[ \t]*:man *:date:* --help"
HISTCONTROL=ignoreboth

HISTFILE=$ZSH_CACHE/.zsh_history
