#!/usr/bin/env bash

backupdir="$HOME/.config/mac.bak/cron"

echo "backing up crontab.txt..."
mkdir -p "$backupdir"
crontab -l > "$backupdir/crontab.txt"

# don't let `crontab -l` fail the script if not exists
exit 0
