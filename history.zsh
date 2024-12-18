# NOTE: share history between multiple shells
setopt SHARE_HISTORY

# NOTE: allow multiple terminal sessions to all append to one zsh command history
setopt APPEND_HISTORY

# NOTE: save the time and how long a command ran
setopt EXTENDED_HISTORY

# NOTE: do not write events to history that are duplicates of the immediately previous event
setopt HIST_IGNORE_DUPS

# NOTE: even if there are commands in-between commands that are the same, still only save the last one
setopt HIST_IGNORE_ALL_DUPS

# NOTE: remove extra blanks from each command line being added to history
setopt HIST_REDUCE_BLANKS

# NOTE: if a line starts with a space, don't save it.
setopt HIST_IGNORE_SPACE

# NOTE: when using a hist thing, make a newline show the change before executing it.
setopt HIST_VERIFY

# NOTE: allows history references to clobber files even when CLOBBER is unset.
setopt HIST_ALLOW_CLOBBER

# NOTE: don't store history (fc -l) command
setopt HIST_NO_STORE

# NOTE: don't store function definitions
setopt HIST_NO_FUNCTIONS

# NOTE: ignores duplicates when writing history file
setopt HIST_SAVE_NO_DUPS

# NOTE: start removing repeating commands when limit of $HISTSIZE is reached
setopt HIST_EXPIRE_DUPS_FIRST

# NOTE: do not display a line previously found
setopt HIST_FIND_NO_DUPS

# NOTE: treat the '!' character specially during expansion
setopt BANG_HIST

HISTSIZE=10000000
SAVEHIST=10000000

HISTIGNORE="ll:ls:history:[bf]g:exit:pwd:clear:[ \t]*:man *:date:* --help:cd:cd *"
HISTCONTROL=ignoreboth

HISTFILE=$ZSH_CACHE/.zsh_history

# NOTE: backup history if needed
function backup_history {
    cp "$HISTFILE" "$HISTFILE.backup.$(date +%Y%m%d%H%M%S)"
}

# NOTE: by default, Zsh only display the last 16 commands
alias history='fc -l 50'
