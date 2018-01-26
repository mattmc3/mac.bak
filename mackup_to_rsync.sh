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

    # comment out anything that's not relevant to what we want to rsync
    # - Comments out headers (ie: [application], [configuration_files])
    # - Comments out the "name =" setting
    # Blanks and comments are fine. If Mackup supports anything else in the
    # future, we may need to modify.
    sed -E 's/^(\[|name ?=)/\# \1/' "$cfg_file" > "$rsync_file.tmp"

    # we have no idea what's a directory and what's a file without testing
    # everything. And, since we probably have configs for things that aren't
    # installed, testing won't tell us accurately anyway.
    # Rsync doesn't really care, so if we expand everything to treat it like
    # it's both a file and a directory we should be fine.
    #
    # `awk '!/[^\#]/ || !seen[$0]++'` is a uniq trick without the need for a
    # sort which ignores blank lines and comment lines
    awk -F"/" '{
        p=""
        # expand each ancestor folder separately because rsync requires it
        for(i=1; i<=NF; i++) {
            print p $i;
            p=p $i "/";
        }
        if (length($0) == 0) {
            print ""  # keep blanks
        }
        else if( $0 !~ /^ *#/ ) {
            print $0 "/**";  # get everything under the dir specified
        }
    }' "$rsync_file.tmp" | awk '!/[^\#]/ || !seen[$0]++' > "$rsync_file.tmp2"

    # now, remove comments and blanks
    cat "$rsync_file.tmp2" | grep -Ev '(#.*$)|(^$)' > "$rsync_file"
    # cat "$rsync_file.tmp2" > "$rsync_file"

    # clean up temp file(s)
    rm "$rsync_file.tmp"
    rm "$rsync_file.tmp2"
}


FILES="${MACKUPDIR}/*.cfg"
for f in $FILES; do
    covert_cfg_to_rsync $f
done
