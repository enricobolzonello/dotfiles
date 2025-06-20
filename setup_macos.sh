#!/bin/bash

# install brew packages
brew bundle --file=~/dotfiles/macos/Brewfile

# set fish as default shell
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish