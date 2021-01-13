#!/usr/bin/env zsh

PS1=
ZINIT_HOME=~/.zinit
declare -A ZINIT
ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1

if [[ ! -f $ZINIT_HOME/bin/zinit.zsh ]]; then
  git clone https://github.com/zdharma/zinit $ZINIT_HOME/bin
  zcompile $ZINIT_HOME/bin/zinit.zsh
fi

ZSH_AUTOLOAD=${ZSH_CONF}/autoload
fpath+="${ZSH_AUTOLOAD}"
if [[ -d "$ZSH_AUTOLOAD" ]]; then
    for func in $ZSH_AUTOLOAD/*; do
        autoload -Uz ${func:t}
    done
fi
unset ZSH_AUTOLOAD

source ~/.zinit/bin/zinit.zsh

zinit ice depth=1 atload"source $ZSH_CONF/.p10k.zsh; _p9k_precmd" nocd wait'!' lucid
# NOTE: my fork turns off the warning about instant prompt
# zinit light romkatv/powerlevel10k
# zinit snippet $ZSH_CONF/.p10k.zsh
zinit light scalp42/powerlevel10k

zinit wait lucid for    \
  OMZL::directories.zsh \
  OMZL::completion.zsh  \
  OMZL::termsupport.zsh \
  OMZL::compfix.zsh

zinit snippet $ZSH_CONF/history.zsh
zinit ice wait lucid; zinit snippet $ZSH_CONF/alias.zsh
zinit ice wait=1 lucid; zinit snippet $ZSH_CONF/functions.zsh
zinit ice wait=1 lucid; zinit snippet $ZSH_CONF/exports.zsh
zinit ice wait=1 lucid; zinit snippet $ZSH_CONF/eval.zsh

zinit ice silent wait=1; zinit light asdf-vm/asdf

zinit ice as"completion" wait=1 lucid
zinit snippet OMZ::plugins/fd/_fd

zinit ice wait=1 lucid atload"autoload -Uz compinit && compinit -d $ZSH_COMPDUMP && zicdreplay -q"
zinit light unixorn/fzf-zsh-plugin

# NOTE: opens in current window instead of new one
# zinit ice wait lucid; zinit light valentinocossar/sublime

zinit ice wait=1 lucid as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"PREFIX=$ZPFX"
zinit light tj/git-extras

zinit wait=1 lucid for            \
  OMZP::cp                        \
  OMZP::sublime                   \
  OMZP::encode64                  \
  djui/alias-tips                 \
  OMZP::colored-man-pages         \
  OMZP::safe-paste                \
  OMZP::urltools                  \
  ChrisPenner/copy-pasta          \
  peterhurford/git-it-on.zsh      \
  rtuin/zsh-case                  \
  caarlos0-graveyard/zsh-git-sync \
  rummik/zsh-ing                  \
  robertzk/send.zsh               \
  OMZP::sublime-merge             \

zinit ice svn wait=1 as=null lucid; zinit snippet PZTM::archive

# NOTE: https://github.com/zsh-users/zsh-autosuggestions
# zinit ice wait"1" lucid atload"!_zsh_autosuggest_start"
# zinit light zsh-users/zsh-autosuggestions

# NOTE: https://github.com/paoloantinori/hhighlighter
zinit ice pick"h.sh" wait"1" lucid; zinit light paoloantinori/hhighlighter

# NOTE: https://github.com/hlissner/zsh-autopair
zinit ice wait=2 lucid; zinit light hlissner/zsh-autopair

# NOTE: https://github.com/Aloxaf/fzf-tab
zinit ice wait=2 lucid; zinit light Aloxaf/fzf-tab

# NOTE: https://github.com/marzocchi/zsh-notify
# NOTE: brew install terminal-notifier
zinit ice wait lucid atload'
  zstyle ":notify:*" error-title "Failed (in #{time_elapsed} seconds)"
  zstyle ":notify:*" success-title "Done (in #{time_elapsed} seconds)"
  zstyle ":notify:*" command-complete-timeout 15
  zstyle ":notify:*" enable-on-ssh yes
  zstyle ":notify:*" blacklist-regex "find|git|cd|l|ll|ls|cat|bat|man|gti|ag|nano"'
zinit light marzocchi/zsh-notify

# zinit ice wait lucid atload"
#   zstyle ':prezto:module:ssh:load' identities 'id_rsa' 'id_rsa_packer' 'id_rsa_terraform' 'id_rsa_inspec'
# "
# zinit snippet PZT::modules/ssh/init.zsh

# NOTE: https://github.com/axtl/gpg-agent.zsh
# zinit ice wait"1" lucid
# zinit light axtl/gpg-agent.zsh

# NOTE: https://github.com/supercrabtree/k
zinit ice wait"2" lucid
zinit light supercrabtree/k

# NOTE: https://github.com/mdumitru/last-working-dir
zinit light mdumitru/last-working-dir

# NOTE: load last
zinit ice wait silent nocompletions lucid atinit"autoload -Uz compinit && compinit -d $ZSH_COMPDUMP && zicdreplay -q"
zinit light zdharma/fast-syntax-highlighting
