# NOTE: completion styles, loaded from zinit.zsh before compinit. Trimmed from
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/completion.zsh to the styles that still
# matter with fzf-tab driving the menu

setopt complete_in_word         # NOTE: allow completion within a word
setopt always_to_end            # NOTE: always move the cursor to the end after completion

# NOTE: case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# NOTE: complete . and .. as directories
zstyle ':completion:*' special-dirs true

# NOTE: cache expensive completions (brew, docker, ...) under $ZSH_CACHE
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE"

# NOTE: fzf-tab needs zsh's own menu off to capture the unambiguous prefix
# (https://github.com/Aloxaf/fzf-tab#usage)
zstyle ':completion:*' menu no

# NOTE: control the order of directory completions
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
