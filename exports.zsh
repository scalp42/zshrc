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

# NOTE: set GOPATH, GOBIN, and PNPM_HOME early so they're available for the loop
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"
export PNPM_HOME="${HOME}/Library/pnpm"

# NOTE: the M1 still runs asdf while the M5 moved to mise, so both version managers are
# optional below and each block only kicks in when its tool is installed on the machine
# _path_head collects the entries that must come before everything else, in order
_path_head=()

# NOTE: asdf shims must be the very first PATH entry so they win over Homebrew
if [[ -d "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" ]]; then
  _path_head+=("${ASDF_DATA_DIR:-$HOME/.asdf}/shims")
  export ASDF_FORCE_PREPEND=true
  export ASDF_HASHICORP_OVERWRITE_ARCH='arm64'
fi

# NOTE: Homebrew Ruby goes right after the asdf shims so asdf can still route project-specific
# versions, but its "system" fallback (from `ruby system` in ~/.tool-versions) finds Homebrew's
# 4.x instead of the macOS /usr/bin ruby 2.6, the gems bindir must also beat /usr/bin, which
# ships ancient bundle/rake/irb stubs for that system ruby
# with mise, `ruby = "path:/opt/homebrew/opt/ruby"` in mise.toml prepends the same bin dir on
# every prompt, so on the M5 the ruby entry here is a harmless duplicate
# gems bindir uses ruby's ABI version (X.Y.0), derived from the cellar symlink so minor upgrades
# (e.g. 4.0.x -> 4.1.x) are picked up automatically
if [[ -x "${HOMEBREW_PREFIX}/opt/ruby/bin/ruby" ]]; then
  _ruby_abi="${$(readlink "${HOMEBREW_PREFIX}/opt/ruby")##*/}"
  _ruby_abi="${_ruby_abi%.*}.0"
  _path_head+=(
    "${HOMEBREW_PREFIX}/opt/ruby/bin"
    "${HOMEBREW_PREFIX}/lib/ruby/gems/${_ruby_abi}/bin"
  )
  unset _ruby_abi
fi

path=(
  $_path_head
  /usr/local/opt/coreutils/libexec/gnubin
  "${HOMEBREW_PREFIX}/bin"
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
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  $path
)
unset _path_head

# NOTE: add directories that may not exist, but should be in PATH if they do
for dir in \
  "${GOBIN}" \
  "${HOME}/.cargo/bin" \
  "${HOME}/.krew/bin" \
  "${HOME}/.rd/bin" \
  "${HOME}/.local/bin" \
  "${PNPM_HOME}"
do
  [[ -d "${dir}" ]] && path+=("${dir}")
done

# NOTE: mise (replaces asdf on the M5) hooks into precmd and prepends its tool bins to PATH on
# every prompt, so it is activated here, after the path array above is final, rather than in
# eval.zsh, the activation script is cached and compiled like the ones in eval.zsh
# after a mise upgrade: rm "$ZSH_CACHE/mise.zsh"
if [[ -x "${HOMEBREW_PREFIX}/bin/mise" ]]; then
  if [[ ! -f "$ZSH_CACHE/mise.zsh" ]]; then
    "${HOMEBREW_PREFIX}/bin/mise" activate zsh > "$ZSH_CACHE/mise.zsh"
  fi
  compile_and_source "$ZSH_CACHE/mise.zsh"
fi

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
# NOTE: aws-vault takes over
# export AWS_DEFAULT_REGION="us-west-2"
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
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export ANDROID_HOME="$HOME/Library/Android/sdk"

# NOTE: source secrets if present
if [[ -f "$ZSH_HOME/secrets/exports.zsh" ]]; then
  source "$ZSH_HOME/secrets/exports.zsh"
fi
