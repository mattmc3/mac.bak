#!/usr/bin/env bash

backupdir="$HOME/.config/mac.bak/vscode"

if type code > /dev/null 2>&1 ; then
    mkdir -p "$backupdir"
    echo "backing up visual-studio-code extentions..."
    code --list-extensions > "$backupdir/extensions.txt"
    # cat "$backupdir/extensions.txt"
else
    echo "skipping visual-studio-code..."
fi
