# NOTE: `brew shellenv` only produces these constants on Apple Silicon, exporting them
# statically saves a ~9ms fork on every shell start. The bin and sbin dirs are prepended here
# so the `${+commands[...]}` probes below find Homebrew tools even when the inherited PATH
# lacks them, exports.zsh rebuilds the full array later and `typeset -U path` in .zshrc drops
# the duplicates. The site-functions dir goes on fpath because the system /bin/zsh does not
# have it compiled in, only the Homebrew zsh does
if [[ -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
  # NOTE: guarded so nested shells don't prepend the same entry again
  [[ ":${INFOPATH:-}:" == *:/opt/homebrew/share/info:* ]] || export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
  fpath=("/opt/homebrew/share/zsh/site-functions" $fpath)
  # NOTE: a leading ":" tells man to search its default paths too, mirrors `brew shellenv`
  [[ -z "${MANPATH-}" ]] || export MANPATH=":${MANPATH#:}"
fi

# NOTE: the blocks below cache each tool's init script via cache_init (functions.zsh), which
# regenerates the cache whenever the tool's binary is newer than it

# NOTE: https://starship.rs
if (( ${+commands[starship]} )); then
  cache_init starship "${commands[starship]}" starship init zsh
fi

# NOTE: https://github.com/gsamokovarov/jump
if (( ${+commands[jump]} )); then
  cache_init jump "${commands[jump]}" jump shell zsh
fi

# NOTE: https://github.com/junegunn/fzf#setting-up-shell-integration
if (( ${+commands[fzf]} )); then
  cache_init fzf "${commands[fzf]}" fzf --zsh
fi

# NOTE: Ctrl-R keeps every command in the history file but hides navigation noise from the
# search list. fzf's stock widget pipes the history array through perl and fzf with no hook to
# filter it (its `fc -rl 1` branch only runs when perl is missing), so the widget is replaced by
# a copy of that pipeline with a grep step in the middle. It reuses fzf's own __fzf_defaults and
# __fzfcmd helpers, so FZF_CTRL_R_OPTS, colors and fzf-tmux keep working, and is only installed
# when those helpers and perl exist, otherwise fzf's unfiltered widget stays bound
if (( ${+functions[__fzf_defaults]} && ${+functions[__fzfcmd]} && ${+commands[perl]} )); then
  fzf-history-widget() {
    local selected
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases no_glob no_sh_glob no_ksharrays extendedglob 2>/dev/null
    zmodload -F zsh/parameter p:history 2>/dev/null
    # NOTE: records are "<event>\t<command>\0" and grep -z works on NUL-terminated records, so a
    # multi-line command is judged as a whole. Dropped: bare or argumented ls/ll/la/l/cd/pwd/
    # clear/exit/xi/history/bg/fg/date, man pages and anything ending in --help
    selected="$(printf '%s\t%s\000' "${(kv)history[@]}" |
      perl -0 -ne 'if (!$seen{(/^\s*[0-9]+\**\t(.*)/s, $1)}++) { s/\n/\n\t/g; print; }' |
      command grep -zvE $'^[0-9]+\\*?\t((ls|ll|la|l|cd|pwd|clear|exit|xi|history|bg|fg|date)( .*)?|man .*|.* --help)$' |
      FZF_DEFAULT_OPTS=$(__fzf_defaults "" "-n2..,.. --scheme=history --bind=ctrl-r:toggle-sort,alt-r:toggle-raw --wrap-sign '\t↳ ' --highlight-line --multi ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} --read0") \
      FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd))"
    local ret=$?
    local line
    local -a cmds mbegin mend match
    if [[ -n "$selected" ]]; then
      if [[ $selected == <->$'\t'* ]]; then
        for line in ${(ps:\n:)selected}; do
          if [[ $line == (#b)(<->)(#B)$'\t'* ]]; then
            (( ${+history[${match[1]}]} )) && cmds+=("${history[${match[1]}]}")
          fi
        done
        if (( ${#cmds[@]} )); then
          BUFFER="${(pj:\n:)${(@)cmds%%$'\n'#}}"
          CURSOR=${#BUFFER}
        fi
      else
        # NOTE: selected is the typed query, not a history entry
        LBUFFER="$selected"
      fi
    fi
    zle reset-prompt
    return $ret
  }
  zle -N fzf-history-widget
fi

# NOTE: secrets evals
if [[ -f "$ZSH_HOME/secrets/eval.zsh" ]]; then
  source "$ZSH_HOME/secrets/eval.zsh"
fi
