#!/usr/bin/env fish

# dock, hot corners
defaults write com.apple.dock autohide -int 1
defaults write com.apple.dock wvous-br-corner -int 13
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock show-recents -int 0

# finder
defaults write com.apple.finder ShowStatusBar -int 1

# key repeat
defaults write 'Apple Global Domain' InitialKeyRepeat -int 15
defaults write 'Apple Global Domain' KeyRepeat -int 2
defaults write com.apple.Accessibility KeyRepeatDelay -float 0.25
defaults write com.apple.Accessibility KeyRepeatEnabled -int 1
defaults write com.apple.Accessibility KeyRepeatInterval -float 0.03333333

# trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1  # tap to click
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0  # light click force

# input menu in menu bar
defaults write com.apple.TextInputMenu visible -int 0

# quotes
defaults write 'Apple Global Domain' NSUserQuotesArray '("\"", "\"", "\'", "\'")'

# screen saver
defaults -currentHost write com.apple.screensaver idleTime -int 300

# shortcuts
defaults write 'Apple Global Domain' NSUserKeyEquivalents '{ "Actual Size" = "@0"; "Zoom In" = "@="; "Zoom Out" = "@-"; }'

