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

# NOTE: set GOPATH and GOBIN early so they're available for the loop
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

path=(
  "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
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

# NOTE: add directories that may not exist, but should be in PATH if they do
for dir in \
  "${GOBIN}" \
  "${HOME}/.cargo/bin" \
  "${HOME}/.krew/bin" \
  "${HOME}/.rd/bin"
do
  [[ -d "${dir}" ]] && path+=("${dir}")
done

# NOTE: don't clear the screen after quitting a manual page
export MANPAGER="less -X"

# NOTE: zsh options
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
export ASDF_FORCE_PREPEND=true
export ASDF_HASHICORP_OVERWRITE_ARCH='arm64'

# NOTE: source secrets if present
if [[ -f "$ZSH_HOME/secrets/exports.zsh" ]]; then
  source "$ZSH_HOME/secrets/exports.zsh"
fi
