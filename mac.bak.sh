#!/usr/bin/env bash

# mac.bak.sh v1.0
# author: mattmc3
# revision: 2018-01-23

# Runs an rsync backup to whatever directory you specify

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# backup
BACKUPDIR="${1:-${current_dir}/backups}"
BACKUPDIR=${BACKUPDIR%/}
echo $BACKUPDIR

# configs/custom
config_dir="${current_dir}/configs"
app_dir="${current_dir}/applications"
custom_dir="${current_dir}/custom"
rsync_appincludes="${current_dir}/rsync_appincludes.txt"

# get all instructions files into one
cat "${app_dir}"/*.txt > "${rsync_appincludes}.tmp"
cat "${custom_dir}"/*.txt >> "${rsync_appincludes}.tmp"

# `awk '!/[^\#]/ || !seen[$0]++'` is a uniq trick without the need for a sort
cat "${rsync_appincludes}.tmp" | awk '!/[^\#]/ || !seen[$0]++' > "${rsync_appincludes}"
rm "${rsync_appincludes}.tmp"

# rsync
rsync -acvL --delete-excluded \
            --include-from="${config_dir}/header.txt" \
            --include-from="${rsync_appincludes}" \
            --include-from="${config_dir}/footer.txt" \
            "$HOME/" "$BACKUPDIR/"
