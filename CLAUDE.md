# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal zsh configuration, modular by design. Symlinked from `~/.zsh` and loaded via `~/.zshrc` → `.zshrc` entry point. No build system, no tests - changes are validated by restarting the shell.

## Architecture

**Entry point:** `.zshrc` sets `$ZSH_HOME`, `$ZSH_CACHE`, bootstraps zinit, then sources `zinit.zsh` which orchestrates all module loading.

**Load order matters:**
1. `.zshrc` - bootstraps zinit, sets core env vars (`ZSH_HOME`, `ZSH_CACHE`, `ZSH_COMPDUMP`)
2. `zinit.zsh` - loads modules via zinit snippets/plugins in this order:
   - `history.zsh` → `alias.zsh` → `functions.zsh` → `eval.zsh` → `directories.zsh` (deferred)
   - External plugins (zsh-completions, fzf-tab, zsh-notify, etc.) with turbo loading
   - `exports.zsh` sourced last (not via zinit) so PATH takes precedence
3. `eval.zsh` - cached eval init for brew, starship, jump, ngrok (uses `compile_and_source()` from `functions.zsh`)
4. `exports.zsh` - PATH construction, zsh options, env vars; must load after eval.zsh

**Secrets:** `secrets/` directory is gitignored. Three hook points auto-source secrets if present:
- `secrets/exports.zsh` (from `exports.zsh`)
- `secrets/alias.zsh` (from `alias.zsh`)
- `secrets/eval.zsh` (from `eval.zsh`)

**Caching strategy:** `eval.zsh` caches slow shell inits (starship, jump, chefvm, ngrok) to `$ZSH_CACHE/` as `.zsh` files, then compiles them to `.zwc` via `compile_and_source()`. Delete cached files to force regeneration.

**Starship config:** `starship.toml` must be symlinked to `~/.config/starship.toml` to take effect.

## Key conventions

- Comments use `# NOTE: ` or `# TODO: ` prefix, no trailing period
- `eza` replaces `ls` (aliased as `ll`, `la`, `tree`, etc.)
- `bat` replaces `cat` (aliased with `-pP` flags)
- `safe-rm` replaces `rm`
- `viddy` replaces `watch` (via wrapper function)
- zinit turbo loading is used for non-critical plugins to speed up shell startup

## Common operations

- **Measure shell startup time:** `avg-time 50` (runs 50 iterations)
- **Update all zinit plugins:** `zupdate`
- **Clean zinit:** `zclean`
- **Backup zsh config to iCloud:** `backup_zsh`
- **Regenerate cached evals:** delete files in `~/.zsh/cache/` and restart shell
