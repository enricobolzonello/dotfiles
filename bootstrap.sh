#!/usr/bin/env bash
#
# Bootstrap dotfiles on a new machine:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/enricobolzonello/dotfiles/main/bootstrap.sh)"
#
# Usage:
#   ./bootstrap.sh [--stow-only] [--dry-run]

echo "      _       _         __ _ _"
echo "   __| | ___ | |_      / _(_) | ___  ___"
echo "  / _\` |/ _ \| __|____| |_| | |/ _ \/ __|"
echo " | (_| | (_) | ||_____|  _| | |  __/\__ \\"
echo "  \__,_|\___/ \__|    |_| |_|_|\___||___/"
echo ""

set -e

## Argument parsing
DRY_RUN=false
STOW_ONLY=false

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dry-run)    DRY_RUN=true ;;
    --stow-only)  STOW_ONLY=true ;;
    -h|--help)
      echo "Usage: bootstrap.sh [--stow-only] [--dry-run]"
      echo "  --stow-only  Skip package installation"
      echo "  --dry-run    Print commands without executing them"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

[[ "$DRY_RUN" == "true" ]] && echo "Running in dry-run mode — no changes will be made."

trap 'echo ""; echo "Exiting bootstrap script..."; exit 130' SIGINT SIGTERM

## Execute or print depending on dry-run mode
run() {
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "[dry-run] $*"
  else
    eval "$@"
  fi
}

## Stow a package, backing up any conflicting real files first
safe_stow() {
  local pkg=$1
  if [[ "$DRY_RUN" == "false" ]]; then
    local conflicts
    conflicts=$(stow -d "$DOTFILES_DIR" -t "$HOME" --simulate "$pkg" 2>&1 \
      | grep "existing target is neither" | sed 's/.*: //' || true)
    while IFS= read -r target; do
      [[ -z "$target" ]] && continue
      local full_path="$HOME/$target"
      if [[ -e "$full_path" && ! -L "$full_path" ]]; then
        mv "$full_path" "${full_path}.bak"
        echo "Backed up $full_path → ${full_path}.bak"
      fi
    done <<< "$conflicts"
  fi
  run stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
}

## OS detection
OS="$(uname -s)"
KERNEL="$(uname -r)"
echo "Detected OS: $OS | Kernel: $KERNEL"

if ! [[ "$OS" == "Darwin" || "$OS" == "Linux" ]]; then
  echo "Unsupported OS: $OS"
  exit 1
fi

## Auto-clone if the dotfiles repo is not present
DOTFILES_DIR="$HOME/dotfiles"
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Cloning dotfiles..."
  run git clone https://github.com/enricobolzonello/dotfiles "$DOTFILES_DIR"
fi

## Package installation
if [[ "$STOW_ONLY" == "false" ]]; then
  case "$OS" in
    "Darwin")
      echo "Running macOS setup..."

      if ! command -v brew &>/dev/null; then
        echo "Homebrew not found."
        read -rp "Install Homebrew? [Y/n]: " brewvar
        if [[ ! "$brewvar" =~ ^[Nn] ]]; then
          run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          run eval "$(/opt/homebrew/bin/brew shellenv)"
          command -v brew &>/dev/null || { echo "Homebrew installation failed"; exit 1; }
          echo "Homebrew installed successfully."
        fi
      fi

      run "$DOTFILES_DIR/setup_macos.sh"
      ;;
    "Linux")
      if [[ "$KERNEL" == *"arch"* ]] || [[ "$KERNEL" == *"cachyos"* ]]; then
        echo "Running Arch/CachyOS setup..."
        run "$DOTFILES_DIR/setup_arch.sh"
      else
        echo "Unsupported Linux distro. Exiting."
        exit 1
      fi
      ;;
  esac
else
  echo "Skipping package installation (stow-only mode)."
fi

## Stow dotfiles
echo "Stowing dotfiles..."
safe_stow general
safe_stow claude-code

if [[ "$OS" == "Darwin" ]]; then
  safe_stow macos
  if [[ "$DRY_RUN" == "false" ]]; then
    grep -qxF 'fish_add_path /opt/homebrew/bin' ~/.config/fish/config.fish \
      || echo 'fish_add_path /opt/homebrew/bin' >> ~/.config/fish/config.fish
  else
    echo "[dry-run] append fish_add_path /opt/homebrew/bin to ~/.config/fish/config.fish (if missing)"
  fi
elif [[ "$OS" == "Linux" ]]; then
  safe_stow hyprland
fi

echo "✅ Dotfiles installation complete!"
