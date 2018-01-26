#!/usr/bin/env bash

backupdir="$HOME/.config/mac.bak/brew"

if type brew > /dev/null 2>&1 ; then
    mkdir -p "${backupdir}"
    echo "backing up Brewfile..."
    (cd "$backupdir" && brew bundle dump --force)
else
    echo "homebrew not found... skipping..."
fi
