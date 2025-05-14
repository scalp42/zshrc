function greph () {
  history | grep $1
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn't break anything for binary files)
  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# Gzip-enabled `curl`
function gurl() {
  curl -sH "Accept-Encoding: gzip" "$@" | gunzip
}

# All the dig info
function digg() {
  dig +nocmd "$1" any +multiline +noall +answer
}

# Escape UTF-8 characters into their 3-byte format
function escape() {
  printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
  echo # newline
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
  perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
  echo # newline
}

# Get a character's Unicode code point
function codepoint() {
  perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))"
  echo # newline
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

# NOTE: helper function to handle .zsh -> .zwc compilation and sourcing
compile_and_source() {
  local src="$1"
  local compiled="${src:r}.zwc"

  # NOTE: only compile if source is newer than compiled or compiled doesn't exist
  if [[ -f "$src" && ( ! -f "$compiled" || "$src" -nt "$compiled" ) ]]; then
    zcompile "$src"
  fi

  # NOTE: if compiled exists, source it; otherwise source the plain file
  if [[ -f "$compiled" ]]; then
    source "$compiled"
  else
    [[ -f "$src" ]] && source "$src"
  fi
}

# FIXME: hangs, not working
# zcompile_eval() {
#   local filename="${ZSH_CACHE}/${1}"
#   shift

#   if [ ! -f "$filename" ]; then
#     mkdir -p "$(dirname "$filename")"
#     "$@" > "$filename"
#     zcompile "$filename"
#   fi

#   source "$filename"
# }

function omz_urlencode() {
  emulate -L zsh
  # If the first argument is "-P", skip it.
  if [[ "$1" == "-P" ]]; then
    shift
  fi
  local string="$1"
  if command -v python3 > /dev/null 2>&1; then
    python3 -c "import urllib.parse, sys; sys.stdout.write(urllib.parse.quote(sys.argv[1]))" "$string"
  else
    # A simple fallback (does not encode all characters)
    echo "${string// /%20}"
  fi
}

backup_zsh_function() {
  # NOTE: Set the backup directory
  BACKUP_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/backup"

  # NOTE: Create the backup directory if it doesn't exist
  mkdir -p "$BACKUP_DIR"

  # NOTE: Create a timestamped filename for the backup
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  BACKUP_FILE="zsh_backup_$TIMESTAMP.tar.gz"

  # NOTE: Create the backup using tar (preserves special files)
  tar -czf "/tmp/$BACKUP_FILE" -C "$HOME" .zsh

  # NOTE: Move the backup to iCloud Drive
  mv "/tmp/$BACKUP_FILE" "$BACKUP_DIR/$BACKUP_FILE"

  # NOTE: Keep only the 5 most recent backups
  ls -t "$BACKUP_DIR"/zsh_backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs rm -f 2>/dev/null

  # NOTE: Count remaining backups
  BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/zsh_backup_*.tar.gz 2>/dev/null | wc -l)

  # NOTE: Print success message
  echo "✅ Backup created: $BACKUP_FILE"
  echo "📁 Location: $BACKUP_DIR"
  echo "🔢 Total backups: $BACKUP_COUNT (maximum: 5)"
}

# NOTE: Watch function that uses viddy if available, otherwise uses standard watch
function watch() {
  if command -v viddy &>/dev/null; then
    viddy "$@"
  else
    command watch "$@"
  fi
}
