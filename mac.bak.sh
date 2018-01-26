#!/usr/bin/env bash

# mac.bak.sh v1.1.1
# author: mattmc3
# revision: 2018-01-25

# Run backups to whatever directory you specify

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function usage() {
    echo "Usage:"
    echo "mac.bak.sh "
    echo "mac.bak.sh -h "
    echo "mac.bak.sh --dir=~/backups "
    echo "mac.bak.sh --app=firefox "
    echo ""
    echo "   -a | --app         specify just a single app to backup"
    echo "   -d | --dir         the backup directory"
    echo "   --dry-run          rsync dry run rather than backup"
    echo "   --delete-excluded  rsync delete excluded"
    echo "   -h                 help (this output)"
}

# vars
backupdir="${current_dir}/backups"
app_name=
app_dir="${current_dir}/apps"
custom_dir="${current_dir}/custom"
rsync_combined="${current_dir}/include-from.rsync"
dry_run=
delete_excluded=

# parse command args
while [ "$1" != "" ]; do
    case $1 in
        -d | --dir )         shift
                             backupdir=${1%/}
                             ;;
        -a | --app )         shift
                             app_name=$1
                             ;;
        --dry-run )          dry_run=1
                             ;;
        --delete-excluded )  delete_excluded=1
                             ;;
        -h | --help )        usage
                             exit
                             ;;
        * )                  usage
                             exit 1
    esac
    shift
done

if [[ -z $app_name ]]; then
    echo "Backing up everything to ${backupdir}"
else
    echo "Backing up ${app_name} to ${backupdir}"
    app_dir="${app_dir}/${app_name}"
fi

# first run all backup.sh scripts
if [[ -z $dry_run ]]; then
    find "${app_dir}" -type f -name 'backup.sh' -exec {} \;
else
    echo "skipping backup.sh scripts for dry-run"
fi

# get all rsync instructions files into one
find "${app_dir}" -type f -name 'include-from.rsync' -exec cat {} \; > "${rsync_combined}.tmp"
find "${custom_dir}" -type f -name 'include-from.rsync' -exec cat {} \; >> "${rsync_combined}.tmp"

# `awk '!/[^\#]/ || !seen[$0]++'` is a uniq trick without the need for a sort
cat "${rsync_combined}.tmp" | awk '!/[^\#]/ || !seen[$0]++' > "${rsync_combined}"
rm "${rsync_combined}.tmp"

# rsync
rsync_cmd="rsync -acvL "
if [[ ! -z $dry_run ]]; then
    rsync_cmd+="--dry-run "
fi
if [[ ! -z $delete_excluded ]]; then
    rsync_cmd+="--delete-excluded "
fi
rsync_cmd+="--include-from=\"${current_dir}/header.rsync\" "
rsync_cmd+="--include-from=\"${rsync_combined}\" "
rsync_cmd+="--include-from=\"${current_dir}/footer.rsync\" "
rsync_cmd+="\"$HOME/\" \"$backupdir/\""

echo $rsync_cmd
eval $rsync_cmd
rm "${rsync_combined}"
