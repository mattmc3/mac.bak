#!/usr/bin/env bash

backupdir="$HOME/.config/mac.bak/vscode"

if type code > /dev/null 2>&1 ; then
    echo "restoring vscode packages"
    cat "$backupdir/extensions.txt" | xargs -L 1 code --install-extension
fi
