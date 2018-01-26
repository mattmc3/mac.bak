#!/usr/bin/env bash

backupdir="$HOME/.config/mac.bak/macos"

echo "backing up list of mac apps..."
mkdir -p "$backupdir"
ls -1 /Applications > "$backupdir/macapps.txt"
