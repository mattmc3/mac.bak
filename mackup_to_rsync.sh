#!/usr/bin/env bash

# mackup_to_rsync.sh v1.0.1
# author: mattmc3
# revision: 2018-01-23

# Mackup is cool, but it symlinks files. I don't want that. Hmmm...
# wait a second... those mackup .cfg files look suspiciously like an rsync
# filter list. Let's abandon this `ln` symlink mess and just make an rsync
# backup of everything.

MACKUPDIR=${1%/}
OUTDIR=${2%/}

if [[ ! -d $MACKUPDIR ]]; then
    echo "You must supply a dir containing mackup .cfg files"
    exit 1
elif [[ -z $OUTDIR ]]; then
    echo "You must supply an output dir for mackup .cfg files to get converted"
    exit 1
fi


function covert_cfg_to_rsync() {
    local cfg_file=$1
    local rsync_dir="${OUTDIR}/$(basename ${cfg_file%.*})"
    local rsync_file="${rsync_dir}/include-from.rsync"

    mkdir -p "${rsync_dir}"

    # Parse the Mackup cfg file to extract just configuration paths
    # and prefix XDG paths with .config/
    awk '
    BEGIN {
        in_config = 0
        in_xdg = 0
    }

    /^\[configuration_files\]/ {
        in_config = 1
        in_xdg = 0
        next
    }

    /^\[xdg_configuration_files\]/ {
        in_config = 0
        in_xdg = 1
        next
    }

    /^\[.*\]/ {
        in_config = 0
        in_xdg = 0
        next
    }

    /^[^#]/ && NF > 0 {
        if (in_config) {
            print $0
        } else if (in_xdg) {
            print ".config/" $0
        }
    }
    ' "$cfg_file" > "$rsync_file.tmp"

    # Process each path to generate rsync rules
    awk -F"/" '{
        if (length($0) == 0) next;

        p=""
        # First print the full path
        print $0;

        # Then expand each ancestor folder separately because rsync requires it
        for(i=1; i<NF; i++) {
            path = "";
            for(j=1; j<=i; j++) {
                if (j > 1) path = path "/";
                path = path $j;
            }
            print path;
        }

        # Add wildcard to get everything under the specified path
        print $0 "/**";
    }' "$rsync_file.tmp" | sort | uniq > "$rsync_file"

    # Clean up temp file
    rm "$rsync_file.tmp"
}

FILES="${MACKUPDIR}/*.cfg"
for f in $FILES; do
    echo "creating rsync file from mackup cfg for: ${f##*/}"
    covert_cfg_to_rsync $f
done
