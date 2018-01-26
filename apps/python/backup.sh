#!/usr/bin/env bash

backupdir="$HOME/.config/mac.bak/python"

pips=(pip2 pip3)
for pip in "${pips[@]}" ; do
    if type $pip > /dev/null 2>&1 ; then
        mkdir -p "$backupdir"
        echo "backing up python $pip package list..."
        $pip freeze > "$backupdir/${pip}_requirements.txt"
    else
        echo "skipping $pip..."
    fi
done
