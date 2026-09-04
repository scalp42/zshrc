export EDITOR="nano"
export VISUAL="subl -w -n --"
export PAGER="less"
# NOTE: LANG alone is enough, LC_ALL would override any per-category setting (LC_COLLATE=C ...)
export LANG="en_US.UTF-8"

# NOTE: eval.zsh normally sets HOMEBREW_PREFIX, the default keeps the PATH below sane if it didn't
: ${HOMEBREW_PREFIX:=/opt/homebrew}

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
  # NOTE: the gems bindir is found with a glob (no fork) and only the newest ABI dir is taken,
  # `n` sorts numerically so 10.x beats 4.x and `On[1]` keeps the first entry in descending order
  _path_head+=(
    "${HOMEBREW_PREFIX}/opt/ruby/bin"
    "${HOMEBREW_PREFIX}"/lib/ruby/gems/*/bin(N/nOn[1])
  )
fi

path=(
  $_path_head
  "${HOMEBREW_PREFIX}/bin"
  "${HOMEBREW_PREFIX}/sbin"
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  "/Applications/Google Chrome.app/Contents/MacOS"
  $path
)
unset _path_head

# NOTE: add directories that may not exist, but should be in PATH if they do. /usr/local/bin is
# not listed because macOS's path_helper already puts it in the inherited PATH via /etc/paths
for dir in \
  /usr/local/sbin \
  "${GOBIN}" \
  "${HOME}/.cargo/bin" \
  "${HOME}/.krew/bin" \
  "${HOME}/.rd/bin" \
  "${HOME}/.local/bin" \
  "${HOME}/.lmstudio/bin" \
  "${PNPM_HOME}/bin" \
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin" \
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
do
  [[ -d "${dir}" ]] && path+=("${dir}")
done

# NOTE: mise (replaces asdf on the M5) hooks into precmd and prepends its tool bins to PATH on
# every prompt, so it is activated here, after the path array above is final, rather than in
# eval.zsh, and cache_init regenerates the cached activation script after a mise upgrade
# The current shell's mise state is stripped from the generator's environment: with MISE_SHELL
# set, `mise activate` emits a deactivate preamble containing a literal PATH snapshot, which
# every later shell would replay over its freshly built path array
if [[ -x "${HOMEBREW_PREFIX}/bin/mise" ]]; then
  cache_init mise "${HOMEBREW_PREFIX}/bin/mise" \
    env -u MISE_SHELL -u __MISE_SESSION -u __MISE_DIFF -u __MISE_ORIG_PATH \
    "${HOMEBREW_PREFIX}/bin/mise" activate zsh
fi

# NOTE: don't clear the screen after quitting a manual page
export MANPAGER="less -X"

# NOTE: zsh options
setopt INTERACTIVECOMMENTS    # allow inline comments
setopt NOCLOBBER              # prevent overwriting files with '>'
setopt RCQUOTES               # allow easier single quote usage
unsetopt FLOW_CONTROL         # disable ^S/^Q flow control

export HOMEBREW_NO_ANALYTICS=1
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
export EZA_COLORS="da=1;34:gm=1;33:ga=1;32:gd=1;31:gv=1;33:gt=1;37:sn=37:sb=37"
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# NOTE: source secrets if present
if [[ -f "$ZSH_HOME/secrets/exports.zsh" ]]; then
  source "$ZSH_HOME/secrets/exports.zsh"
fi
