#!/usr/bin/env bash

backupdir="$HOME/.config/mac.bak/python"

pips=(pip2 pip3)
for pip in "${pips[@]}" ; do
    if type $pip > /dev/null 2>&1 ; then
        echo "restoring python $pip packages..."
        $pip install -r "$backupdir/${pip}_requirements.txt"
    fi
done
