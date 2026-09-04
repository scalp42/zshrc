# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal zsh configuration, modular by design. Symlinked from `~/.zsh` and loaded via `~/.zshrc` → `.zshrc` entry point. No build system, no tests - changes are validated by restarting the shell.

## Architecture

**Entry point:** `.zshrc` sets `$ZSH_HOME`, `$ZSH_CACHE`, bootstraps zinit, then sources `zinit.zsh` which orchestrates all module loading.

**Load order matters:**
1. `.zshrc` - bootstraps zinit, sets core env vars (`ZSH_HOME`, `ZSH_CACHE`, `ZSH_COMPDUMP`)
2. `zinit.zsh` - loads modules via zinit snippets/plugins in this order:
   - `history.zsh` → `alias.zsh` → `functions.zsh` → `eval.zsh` → `completions.zsh` → `directories.zsh` (deferred)
   - copy-pasta (declared before compinit), `zsh-completions`, then `compinit` (with `-C`, a full compaudit run happens once a day keyed on the dump's mtime), then fzf-tab, zsh-autosuggestions, hhighlighter. All four plugins are deferred with `wait'N'` (zinit's turbo mode; there is no `turbo` ice), so declaration order only matters for the ones that must follow compinit
   - `exports.zsh` sourced last (not via zinit) so PATH takes precedence
3. `eval.zsh` - static Homebrew exports plus a bin/sbin PATH prepend (replaces the `brew shellenv` fork), cached init for starship, jump, fzf via `cache_init()` from `functions.zsh`, and a local copy of fzf's Ctrl-R widget with a grep step that hides navigation noise (`cd`, `ls`, `man`, `--help`, ...) from the search list while the history file keeps everything
4. `exports.zsh` - PATH construction, zsh options, env vars; must load after eval.zsh. Detects the version manager per machine: asdf shims + `ASDF_*` exports when `~/.asdf/shims` exists (M1), cached `mise activate` when `/opt/homebrew/bin/mise` exists (M5). Homebrew Ruby and its gems bindir are placed ahead of `/usr/bin` on both

**Secrets:** `secrets/` directory is gitignored and mode 700, files 600. Three hook points auto-source secrets if present:
- `secrets/exports.zsh` (from `exports.zsh`). Some values there are intentionally not exported so child processes don't inherit them; `$VAR` still expands at the prompt
- `secrets/alias.zsh` (from `alias.zsh`)
- `secrets/eval.zsh` (from `eval.zsh`)

**zinit snippet cache:** files loaded via `zinit snippet` (`history.zsh`, `alias.zsh`, `functions.zsh`, `eval.zsh`, `completions.zsh`, `directories.zsh`) are copied into `~/.zinit/snippets/` and sourced from that copy. Editing the original has no effect until `zinit update "$ZSH_HOME/<file>.zsh"` (or `zupdate` for all) refreshes it. Files sourced directly (`.zshrc`, `zinit.zsh`, `exports.zsh`) don't need this.

**Caching strategy:** `cache_init <name> <binary> <command...>` in `functions.zsh` writes a tool's init output to `$ZSH_CACHE/<name>.zsh` and compiles it to `.zwc` via `compile_and_source()`. The cache is regenerated automatically when it is missing, empty, or older than the tool's binary (so `brew upgrade` is enough), and a failed generator never replaces a good cache. `eval.zsh` uses it for starship, jump, fzf; `exports.zsh` for `mise activate` (run with the shell's `MISE_*` state stripped, otherwise mise bakes a PATH snapshot into the cache).

**Starship config:** `starship.toml` must be symlinked to `~/.config/starship.toml` to take effect.

**mise config:** `mise.toml` must be symlinked to `~/mise.toml` to take effect (mise walks up from the cwd to `$HOME`, so a config in the home dir applies everywhere). Only needed on machines running mise.

## Key conventions

- Comments use `# NOTE: ` or `# TODO: ` prefix, no trailing period
- `eza` replaces `ls` (aliased as `ll`, `la`, `tree`, etc.)
- `bat` replaces `cat` (wrapper function in `functions.zsh` running `bat -pP`, falls back to the real `cat` for flags bat lacks)
- `safe-rm` (kaelzhang/shell-safe-rm via `pnpm add -g safe-rm`, moves files to the Trash) replaces `rm` when installed. The Homebrew `safe-rm` formula is an unrelated tool that deletes permanently; do not install it
- `viddy` replaces `watch` (via wrapper function)
- `subl` comes from `/Applications/Sublime Text.app/Contents/SharedSupport/bin` (added to PATH in `exports.zsh`); `VISUAL` and git's `core.editor` both point at it
- zinit turbo loading (`wait'N'` ice) is used for non-critical plugins to speed up shell startup

## Common operations

- **Measure shell startup time:** `avg-time 50` (runs 50 iterations)
- **Update all zinit plugins:** `zupdate`
- **Clean zinit:** `zclean`
- **Backup zsh config to iCloud:** `backup_zsh` (excludes `secrets/`, `cache/`, `.git/`)
- **Regenerate cached evals:** automatic after a tool upgrade; to force it, delete the file in `~/.zsh/cache/` and restart the shell
- **Throwaway Claude sessions:** `claudetmp` in `functions.zsh` runs `claude` from `~/claudetmp`, passing the launch folder with `--add-dir` (skipped for `$HOME`). Plain `claude` is untouched. Refresh the snippet cache after editing: `zinit update "$ZSH_HOME/functions.zsh"`
