#!/bin/sh
set -eux

# Update to Rosetta 2
/usr/sbin/softwareupdate --install-rosetta --agree-to-license

# To install gcc, make etc. we need to include Xcode command line dev tools
if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
    test -d "${xpath}" && test -x "${xpath}" ; then
    echo 'Xcode Command Line Tools already installed...'
    # softwareupdate --all --install --force
else
    echo 'Installing Xcode Command Line Tools...'
    xcode-select --install
fi

mkdir -p ~/Projects

# Remove the directory that we will clone our repo to, so we always get the latest version
rm -rf ~/Projects/mac-setup

git clone https://github.com/kielabokkie/mac-setup.git ~/Projects/mac-setup

cd ~/Projects/mac-setup

# Check for Homebrew, install if we don't have it
if ! command -v brew >/dev/null; then
  echo "Installing Homebrew ..."
    /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/wouter/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo 'Running brew update...'
brew update

command -v ansible >/dev/null 2>&1 || { echo >&2 "Installing Ansible..."; \
brew install ansible; }

cd mac-ansible
make install
