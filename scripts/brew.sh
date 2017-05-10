#!/bin/bash

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install binaries
brew install vim --with-override-system-vi
brew install pip
brew install git
brew install bash-completion
brew install tmux
brew install node
brew install python
brew install python3
brew install reattach-to-user-namespace
brew install screenfetch

# Install apps
brew cask install google-chrome
brew cask install dropbox
brew cask install iterm2
brew cask install evernote
