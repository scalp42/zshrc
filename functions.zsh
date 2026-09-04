# NOTE: search the whole history, the `history` builtin alone only lists recent entries
function greph () {
  fc -l 1 | grep -- "$1"
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn't break anything for binary files)
  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# # Print MySQL grants
# function mygrants()
# {
#   mysql -B -N $@ -e "SELECT DISTINCT CONCAT(
#     'SHOW GRANTS FOR ''', user, '''@''', host, ''';'
#     ) AS query FROM mysql.user" | \
#   mysql $@ | \
#   sed 's/\(GRANT .*\)/\1;/;s/^\(Grants for .*\)/## \1 ##/;/##/{x;p;x;}'
# }

function berkclean () {
  ls -l ~/.berkshelf/cookbooks | sed 1d | awk '{print $9}' | xargs -P20  -I%  sh -c '{ cd ~/.berkshelf/cookbooks/% ; vagrant destroy -f; }'
}

function chefall() {
  CHEF_CONFIG=$(chefvm current)
  for CURRENT_CHEF_CONFIG in $(chefvm completions use | grep -v default)
  do
    chefvm use $CURRENT_CHEF_CONFIG
    $@
  done
  chefvm use $CHEF_CONFIG 2>&1 > /dev/null
}

function timestamp() {
 date +%m-%d-%Y_%T | tr -d '\n'
}

function avg-time() {
    float sum=0
    integer count=${1:-50}
    repeat $count { time zsh -ic exit } |& \
        while IFS='' read line; do
      sum+=${${${line% total}##* }//,/.}
        done
    print $(( sum / count ))
}

if (( ${+commands[jump]} )) jc() { j "$(basename $PWD)/*/$@" }

# NOTE: helper function to handle .zsh -> .zwc compilation and sourcing. zcompile writes
# <src>.zwc, and `source <src>` automatically uses that compiled file whenever it is not older
# than the source, so only the compile step needs a freshness check (a .zwc can't be sourced
# by its own name, zsh would parse the bytecode as text)
compile_and_source() {
  local src="$1"
  [[ -f "$src" ]] || return 1

  if [[ ! -f "$src.zwc" || "$src" -nt "$src.zwc" ]]; then
    zcompile "$src"
  fi

  source "$src"
}

# NOTE: cache_init runs a tool's shell-init command once and caches its output as
# $ZSH_CACHE/<name>.zsh, then compiles and sources it. The cache is regenerated when it is
# missing, empty, or older than the tool's binary, so `brew upgrade` picks up new init code
# without a manual rm. Output goes to a temp file first and only replaces the cache when the
# command succeeded and printed something, so a failed run can't leave an empty cache that is
# sourced forever. Usage: cache_init <name> <binary> <command> [args...]
cache_init() {
  local name="$1" bin="$2"
  shift 2
  local cache="$ZSH_CACHE/$name.zsh"

  if [[ ! -s "$cache" || "$bin" -nt "$cache" ]]; then
    if "$@" >| "$cache.tmp" 2>/dev/null && [[ -s "$cache.tmp" ]]; then
      command mv -f "$cache.tmp" "$cache"
    else
      command rm -f "$cache.tmp"
      print -u2 "cache_init: could not generate $cache from: $*"
      return 1
    fi
  fi

  compile_and_source "$cache"
}

backup_zsh_function() {
  # NOTE: Set the backup directory
  BACKUP_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/backup"

  # NOTE: Create the backup directory if it doesn't exist
  mkdir -p "$BACKUP_DIR"

  # NOTE: Create a timestamped filename for the backup
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  BACKUP_FILE="zsh_backup_$TIMESTAMP.tar.gz"

  # NOTE: secrets/, cache/ and .git/ stay out of the archive, which is built in a private temp
  # dir with a 077 umask
  local staging
  staging="$(mktemp -d)" || return 1
  (
    umask 077
    tar -czf "$staging/$BACKUP_FILE" -C "$HOME" \
      --exclude='.zsh/secrets' \
      --exclude='.zsh/cache' \
      --exclude='.zsh/.git' \
      .zsh
  ) || { command rm -rf "$staging"; return 1 }

  # NOTE: Move the backup to iCloud Drive
  mv "$staging/$BACKUP_FILE" "$BACKUP_DIR/$BACKUP_FILE"
  command rm -rf "$staging"

  # NOTE: Keep only the 5 most recent backups (glob sorted newest first; handles spaces in path)
  local -a backups
  backups=("$BACKUP_DIR"/zsh_backup_*.tar.gz(N.om))
  if (( ${#backups} > 5 )); then
    command rm -f -- "${backups[@]:5}"
  fi

  # NOTE: Count remaining backups
  backups=("$BACKUP_DIR"/zsh_backup_*.tar.gz(N.om))
  BACKUP_COUNT=${#backups}

  # NOTE: Print success message
  echo "✅ Backup created: $BACKUP_FILE"
  echo "📁 Location: $BACKUP_DIR"
  echo "🔢 Total backups: $BACKUP_COUNT (maximum: 5)"
}

# NOTE: keep is the menu bar mouse jiggler in ~/projs/keep. Starts it detached through its
# LaunchAgent when one is installed, otherwise directly; no-op if it is already running
keepbar() {
  local label="com.scalp.keep" plist="$HOME/Library/LaunchAgents/com.scalp.keep.plist"
  if launchctl print "gui/$(id -u)/$label" >/dev/null 2>&1; then
    if launchctl print "gui/$(id -u)/$label" | grep -qE "state.=.running"; then
      echo "keep is already running (check the menu bar)."
    else
      launchctl kickstart "gui/$(id -u)/$label" && echo "keep started."
    fi
  elif [ -f "$plist" ]; then
    launchctl bootstrap "gui/$(id -u)" "$plist" && echo "keep started."
  else
    nohup ~/projs/keep/.venv/bin/python3 ~/projs/keep/keep_menubar.py >>"$HOME/Library/Logs/keep.log" 2>&1 &!
    echo "keep started (no LaunchAgent installed; use 'Start at login' in its menu to add one)."
  fi
}

# NOTE: cat runs bat (plain style, no pager) for highlighted output. The real cat is used when
# bat is not installed (checked on every call, so `brew install bat` works without a new shell)
# and for the flags bat doesn't have (-v -e -t -b -E -T), so `cat -v file` keeps working
cat() {
  if (( ${+commands[bat]} )); then
    local arg
    for arg in "$@"; do
      [[ "$arg" == "--" ]] && break
      if [[ "$arg" == -[^-]* && "$arg" == *[vetbET]* ]]; then
        command cat "$@"
        return
      fi
    done
    bat -pP "$@"
  else
    command cat "$@"
  fi
}

# NOTE: Watch function that uses viddy if available, otherwise uses standard watch
function watch() {
  if command -v viddy &>/dev/null; then
    viddy "$@"
  else
    command watch "$@"
  fi
}

# NOTE: claudetmp starts a throwaway Claude session from ~/claudetmp so the per-directory
# state Claude Code creates (a project entry in ~/.claude.json, ~/.claude/projects/<slug>/,
# .claude/settings.local.json in the cwd) piles up in one disposable place instead of
# wherever the shell happened to be. The launch folder is passed with --add-dir unless
# it is $HOME. Plain `claude` is untouched
function claudetmp() {
  local scratch="$HOME/claudetmp"
  local -a extra

  if [[ "$PWD" != "$HOME" && "$PWD" != "$scratch" ]]; then
    extra=(--add-dir "$PWD")
  fi

  (cd "$scratch" && command claude "${extra[@]}" "$@")
}
