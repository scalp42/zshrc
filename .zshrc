#!/usr/bin/env zsh

export ZSH_HOME=${HOME}/.zsh
export ZSH_CACHE="${ZSH_HOME}/cache"
# NOTE: cache/ is gitignored, so a fresh clone has none and cache_init, compinit and HISTFILE
# would all fail without it
[[ -d "$ZSH_CACHE" ]] || mkdir -p "$ZSH_CACHE"
export ZSH_COMPDUMP="${ZSH_CACHE}/.zcompdump-${(%):-%m}-${ZSH_VERSION}"

# NOTE: keep PATH and fpath free of duplicates, whatever the files below prepend
typeset -U path fpath

# NOTE: zinit routine, the clone only runs on a fresh machine and says so when it fails
# instead of leaving a shell with no plugin manager and no explanation
export ZINIT_HOME="${HOME}/.zinit"
if [[ ! -d "$ZINIT_HOME/.git" ]]; then
  git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" \
    || print -u2 "zinit bootstrap failed, plugins and snippets will not load"
fi
source "${ZINIT_HOME}/zinit.zsh"

# NOTE: load custom zinit config
source $ZSH_HOME/zinit.zsh
