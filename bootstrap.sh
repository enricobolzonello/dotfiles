#!/usr/bin/env bash

echo -e "${COLOR_GREEN}"

echo "      _       _         __ _ _"
echo "   __| | ___ | |_      / _(_) | ___  ___"
echo "  / _\` |/ _ \| __|____| |_| | |/ _ \/ __|"
echo " | (_| | (_) | ||_____|  _| | |  __/\__ \\"
echo "  \__,_|\___/ \__|    |_| |_|_|\___||___/"
echo ""

echo -e "${COLOR_NO_COLOUR}"
set -e

# Check for stow-only flag
STOW_ONLY=false
if [[ "$1" == "--stow-only" ]]; then
  STOW_ONLY=true
fi

# Get kernel and OS info
OS="$(uname -s)"
KERNEL="$(uname -r)"

echo "Detected OS: $OS"
echo "Kernel: $KERNEL"

# Run OS-specific installation script
if [[ "$STOW-ONLY" == false ]]; then
case "$OS" in
  "Darwin")
    echo "Running macOS setup..."
    ./setup_macos.sh
    ;;
  "Linux")
    if [[ "$KERNEL" == *"arch"* ]] || [[ "$KERNEL" == *"cachyos"* ]]; then
      echo "Running Arch/CachyOS setup..."
      ./setup_arch.sh
    else
      echo "Unsupported Linux distro. Exiting."
      exit 1
    fi
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac
else
	echo "Skipping package installation (stow-only mode)."
fi

# Symlink dotfiles using GNU Stow
echo "Symlinking 'general' dotfiles..."
stow general

if [[ "$OS" == "Darwin" ]]; then
  echo "Symlinking 'macos' dotfiles..."
  stow macos
  grep -qxF 'fish_add_path /opt/homebrew/bin' ~/.config/fish/config.fish || echo 'fish_add_path /opt/homebrew/bin' >> ~/.config/fish/config.fish
elif [[ "$OS" == "Linux" ]]; then
  echo "Symlinking 'hyprland' dotfiles..."
  stow hyprland
fi

echo "✅ Dotfiles installation complete!"

