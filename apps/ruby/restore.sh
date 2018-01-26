#!/usr/bin/env bash

backupdir="$HOME/.config/mac.bak/ruby"

if type gem > /dev/null 2>&1 ; then
    echo "restoring ruby gems..."
    cat "$backupdir/gemlist.txt" | awk '{ print $1 }' | xargs gem install --conservative
fi
