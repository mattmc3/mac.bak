#!/usr/bin/env bash

backupdir="$HOME/.config/mac.bak/brew"

if type brew > /dev/null 2>&1 ; then
    echo "restoring apps from Brewfile..."
    (cd "$backupdir" && brew bundle)
fi
