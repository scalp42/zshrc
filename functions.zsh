function greph () {
  history | grep $1
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}"
  open "http://localhost:${port}/"
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
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

# Get a character’s Unicode code point
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
