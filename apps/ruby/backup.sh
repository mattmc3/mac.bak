#!/usr/bin/env bash

backupdir="$HOME/.config/mac.bak/ruby"

if type gem > /dev/null 2>&1 ; then
    mkdir -p "$backupdir"
    echo "backing up ruby gem list..."
    gem list --local > "$backupdir/gemlist.txt"
fi
