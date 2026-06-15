# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

Personal dotfiles for macOS/Linux, targeting zsh, Neovim, tmux, Cursor IDE, and various development tools (C/C++, Go, Python). Configurations are deployed to `$HOME` via symlinks using `deploy.sh`.

## Key Commands

```bash
# Deploy all dotfiles to $HOME (creates symlinks)
./deploy.sh

# Install required packages (Homebrew on macOS, apt on Ubuntu)
./install.sh

# Initialize/update submodules (tmux plugin manager + private configs)
git submodule update --init --recursive
```

## Deployment System

`deploy.sh` uses `git ls-files` to enumerate tracked files, then symlinks each to `$HOME/<relative-path>`. Two control files modify this behavior:

- **`.dotignore`**: Files excluded from deployment (e.g., `deploy.sh`, `README.md`, `private/`)
- **`.dothardlink`**: Files deployed as hard links instead of symlinks (e.g., Firefox profiles, fonts)

The `private/` directory is a git submodule (`git@github.com:ingjieye/dotfile-private.git`) deployed separately but with the same mechanism, stripping the `private/` prefix from target paths.

## Architecture / Key Files

| Path | Purpose |
|------|---------|
| `.zshrc` / `.bashrc` | Shell entry points; exports, aliases, plugin loading via antigen |
| `.tmux.conf` | tmux config; uses TPM (`.tmux/plugins/tpm`); auto-save via tmux-continuum |
| `.config/nvim/` | Neovim config; entry at `init.vim`, Lua config at `lua/init.lua`, plugins via Lazy.nvim |
| `.vimrc` | Vim config (shared base with Neovim) |
| `.gitconfig` | Global git config; uses `delta` as pager; includes work config at `.config/git/work.gitconfig` |
| `Library/Application Support/Cursor/User/` | Cursor IDE settings and keybindings |
| `bin/` | Custom scripts on `$PATH` (e.g., `git-create-mr` for GitLab MR creation) |
| `.clang-format` | Chromium-style C++ formatting |

## Adding New Configurations

1. Place the config file in the repo at its target path relative to `$HOME`
2. Optionally add to `.dotignore` (skip deployment) or `.dothardlink` (hard link instead of symlink)
3. Run `./deploy.sh` to apply

## Submodules

- `.tmux/plugins/tpm` — Tmux Plugin Manager
- `private/` — Private configs (SSH keys, work-specific settings); may not be accessible
