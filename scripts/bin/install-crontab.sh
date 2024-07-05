#!/usr/bin/bash

if [[ "$1" == "" ]]; then
    echo "Usage: install-crontab.sh [crontab definition in string]"
    exit -1
fi

ct=$(crontab -l 2>/dev/null)
if [[ "$ct" == *"$1"* ]]; then
    echo "Crontab already installed: $1"
    exit 0
fi

if [[ "$ct" != "" ]]; then
    ct="$ct\n"
fi

echo "$ct$1" | crontab -
