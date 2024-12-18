# NOTE: source is https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/completion.zsh

# NOTE: load zsh's completion list module (necessary for certain completion features)
# zmodload -i zsh/complist

# NOTE: adjust completion word boundaries
WORDCHARS=''

# NOTE: completion-related options
unsetopt menu_complete          # NOTE: do not autoselect the first completion entry
unsetopt flowcontrol            # NOTE: disable flow control (Ctrl+S/Ctrl+Q)
setopt auto_menu                # NOTE: show completion menu on successive tab press
setopt complete_in_word         # NOTE: allow completion within a word
setopt always_to_end            # NOTE: always move the cursor to the end after completion

# # NOTE: configure matcher-list based on case sensitivity and hyphen insensitivity
# if [[ "$CASE_SENSITIVE" = true ]]; then
#   matcher_list=('r:|=*' 'l:|=* r:|=*')
# elif [[ "$HYPHEN_INSENSITIVE" = true ]]; then
#   matcher_list=('m:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*')
# else
#   matcher_list=('m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*')
# fi
# unset CASE_SENSITIVE HYPHEN_INSENSITIVE

# # NOTE: set the matcher list for completions
# zstyle ':completion:*' matcher-list "${matcher_list[@]}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# NOTE: set additional completion styles
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE"

# NOTE: enable interactive menu selection for all completion contexts
zstyle ':completion:*:*:*:*:*' menu select

# NOTE: customize color settings for kill/process completions
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# NOTE: define the command used to list processes for completions
if [[ "$OSTYPE" = darwin* ]]; then
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm"
else
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
fi

# NOTE: control the order of directory completions
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# NOTE: ignore "system" users during user completions
zstyle ':completion:*:*:*:users' ignored-patterns \
      adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
      clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
      gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
      ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
      named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
      operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
      rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
      _spotlight _windowserver _appleevents _eppc _cms _calendar \
      _xserverdocs _mdnsresponder _dpaudio _postfix _atsserver \
      _timezone _lp _postfix _softwareupdate \
      usbmux uucp vcsa wwwrun xfs '_*'

# NOTE: display single ignored pattern at a time in completions
zstyle '*' single-ignored show

# NOTE: load bash completions if needed (currently commented out for performance)
# autoload -U +X bashcompinit && bashcompinit
