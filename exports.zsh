# NOTE: zsh-autosuggestions settings
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# NOTE: make pasting into terminal faster
export DISABLE_MAGIC_FUNCTIONS=true

export EDITOR="nano"
export VISUAL="subl -w -n --"
export PAGER="less"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# NOTE: normalize and remove duplicates from $path
typeset -U path

path=(
  /usr/local/opt/coreutils/libexec/gnubin
  /usr/local/bin
  /usr/local/opt/ruby/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /usr/X11/bin
  /opt/local/bin
  /usr/local/sbin
  "/Applications/Google Chrome.app/Contents/MacOS"
  $path
)

[[ -d "${HOME}/go/bin" ]] && path+=("${HOME}/go/bin")
[[ -d "${HOME}/.cargo/bin" ]] && path+=("${HOME}/.cargo/bin")
[[ -d "${HOME}/.krew/bin" ]] && path+=("${HOME}/.krew/bin")
[[ -d "${HOME}/.rd/bin" ]] && path+=("${HOME}/.rd/bin")

export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"
path+=("${GOBIN}")

export PATH="${path[@]}"

# NOTE: don't clear the screen after quitting a manual page
export MANPAGER="less -X"

# NOTE: Zsh options
setopt AUTOCD                 # cd by just typing directory name
setopt INTERACTIVECOMMENTS    # allow inline comments
setopt NOCLOBBER              # prevent overwriting files with '>'
setopt RCQUOTES               # allow easier single quote usage
unsetopt FLOW_CONTROL         # disable ^S/^Q flow control

export HOMEBREW_NO_ANALYTICS=1
export TLDR_PARAM="yellow"
export AWS_DEFAULT_REGION="us-west-2"
export AWS_PAGER=
export PYTHONIOENCODING="UTF-8"
# NOTE: enable persistent REPL history for `node`
export NODE_REPL_HISTORY="${HOME}/.node_history"
# NOTE: default entries limit is 1000
export NODE_REPL_HISTORY_SIZE="32768"
# NOTE: use sloppy mode by default, matching web browsers
export NODE_REPL_MODE="sloppy"
# NOTE: https://github.com/junegunn/fzf#settings
export FZF_COMPLETION_TRIGGER='~~'
export ZSH_TMUX_UNICODE=true
export EXA_COLORS="da=1;34:gm=1;33:ga=1;32:gd=1;31:gv=1;33:gt=1;37:sn=37:sb=37"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export ASDF_HASHICORP_OVERWRITE_ARCH='amd64'

# Source secrets if present
if [[ -f "$ZSH_HOME/secrets/exports.zsh" ]]; then
  source "$ZSH_HOME/secrets/exports.zsh"
fi
