#!/usr/bin/env bash
# Apply macOS system defaults.
# Run manually or called from setup_macos.sh.
# Most settings require re-login or app restart to take effect.

set -e

echo "Applying macOS defaults..."

## Dock
defaults write com.apple.dock tilesize -int 56
defaults write com.apple.dock "show-recents" -bool false
defaults write com.apple.dock "wvous-br-corner" -int 14   # Quick Note
defaults write com.apple.dock "wvous-br-modifier" -int 0

## Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"     # list view
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"     # search current folder
defaults write com.apple.finder NewWindowTarget -string "PfDo"          # open to Documents

## Keyboard & input
defaults write NSGlobalDomain "com.apple.keyboard.fnState" -bool true   # fn keys as standard function keys
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2                # full keyboard access

## Trackpad
defaults write NSGlobalDomain "com.apple.trackpad.scaling" -float 0.6875
defaults write NSGlobalDomain "com.apple.trackpad.forceClick" -bool true

## UI
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

## deactivate apple intelligence
defaults write com.apple.CloudSubscriptionFeatures.optIn "545129924" -bool "false"

## Restart affected apps
echo "Restarting Dock and Finder..."
killall Dock
killall Finder

echo "macOS defaults applied."
