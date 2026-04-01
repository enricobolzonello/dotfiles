# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package that gets symlinked into `$HOME`.

| Package | Target | Description |
|---|---|---|
| `general/` | `~` | Cross-platform configs: fish, nvim, tmux, kitty, git, etc. |
| `claude-code/` | `~` | Claude Code settings, commands, keybindings, hooks |
| `macos/` | `~` | macOS-only configs and Brewfile |
| `hyprland/` | `~` | Linux/Arch Hyprland WM configs |

## Setup Commands

```bash
# Full setup (installs packages + stows all dotfiles)
./bootstrap.sh

# Stow only (skip package installation)
./bootstrap.sh --stow-only

# Stow a single package manually
stow general
stow claude-code

# macOS package installation only
./setup_macos.sh   # uses macos/Brewfile via brew bundle

# Arch/CachyOS package installation only
./setup_arch.sh
```

## Architecture

- `bootstrap.sh` detects the OS (Darwin vs Linux/Arch), runs the appropriate setup script, then stows the relevant packages.
- The `general/` package is always stowed; `macos/` is stowed on macOS, `hyprland/` on Linux.
- `general/.config/fish/config.fish` sets `$HOSTNAME` to `"macbook"` or `"linux"` at runtime — some configs branch on this variable.
- `general/.config/nvim/` is a git submodule pointing to an external neovim config repo.
- `claude-code/.claude/` contains Claude Code settings (`settings.json`), custom slash commands (`commands/`), keybindings (`keybindings.json`), and hooks (`hooks.json`).

## Conventions

- Commit messages follow Conventional Commits (`feat:`, `fix:`, `chore:`, etc.).
- Add new cross-platform configs under `general/`, OS-specific ones under the appropriate platform package.
- When adding a new stow package, add a corresponding `stow <package>` call in `bootstrap.sh`.
