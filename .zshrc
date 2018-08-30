# Change default zim location
#export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
#[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Look in ~/.oh-my-zsh/themes/ can be set to "random"
ZSH_THEME="juanghurtado"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(zsh_reload extract cp git sublime docker boot2docker)# gpg-agent)

local ZSH_CONF=$HOME/.zsh
local ZSH_CACHE=$ZSH_CONF/cache

local ZSH_COMPDUMP="$ZSH_CACHE/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

zstyle :omz:plugins:ssh-agent agent-forwarding yes
#zstyle :omz:plugins:ssh-agent identities id_rsa_iad_terraform

source $ZSH/oh-my-zsh.sh

source $ZSH_CONF/eval.zsh
source $ZSH_CONF/alias.zsh
source $ZSH_CONF/history.zsh
source $ZSH_CONF/functions.zsh
source $ZSH_CONF/exports.zsh

#export "GPG_TTY=$(tty)"
#export "SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/nomad nomad
