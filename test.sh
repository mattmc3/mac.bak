MACKUPDIR=$1

if [[ ! -d $MACKUPDIR ]]; then
    echo ":("
    exit 1
else
    echo "woot"
fi
