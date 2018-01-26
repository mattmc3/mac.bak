#!/usr/bin/env bash

backupdir="$HOME/.config/mac.bak/node.js"

if type npm > /dev/null 2>&1 ; then
    mkdir -p "$backupdir"
    echo "backing up node.js global package list..."
    npm ls -g --depth=0 > "$backupdir/npm-list.txt"
fi
