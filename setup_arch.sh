#!/bin/bash
clear

packages=(
    "base-devel"
    "wget"
    "unzip"
    "rsync"
    "git"
    "hyprland"
    "kitty"
    "nvim"
    "oh-my-posh"
    "hyprpaper"
    "waypaper"
    "ttf-font-awesome"
    "rofi-wayland"
    "python-pywal"
    "firefox"
    "nautilus"
    "paru"
    "waybar"
    "grim"
    "slurp"
    "cliphist"
    "wlogout"
    "thunar"
    "xdg-desktop-portal-hyprland"
    "qt5-wayland"
    "qt6-wayland"
    "hyprlock"
    "vim"
    "fastfetch"
    "ttf-fira-sans"
    "ttf-fira-code"
    "ttf-firacode-nerd"
    "jq"
    "brightnessctl"
    "networkmanager"
    "wireplumber"
    "spotify-launcher"
    "obsidian"
)

# todo: visual studio code setup

_isInstalled() {
    package="$1"
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [ -n "${check}" ]; then
        echo 0
        return #true
    fi
    echo 1
    return #false
}

function ask_install() {
  echo
  echo
  read -p"$1 (y/n) " -n 1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 1
  else
    return 0
  fi

}

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root"
  echo "Plese use sudo or su"
  exit 1
fi

sudo pacman -Sy

ask_install "upgrade your system?"
if [[ $? -eq 1 ]]; then
	sudo pacman -Syu
fi

for pkg in "${packages[@]}"; do
	if [[ $(_isInstalled "${pkg}") == 0 ]]; then
		echo ":: ${pkg} is already installed."
		continue
	fi
	sudo pacman -S --needed "$pkg"
done

# cursor
paru -S bibata-cursor-theme-bin

# install grimblast for screenshots
git clone git@github.com:hyprwm/contrib.git
cd grimblast
make && make install

echo "Done"
