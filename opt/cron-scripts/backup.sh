#!/usr/bin/bash

function panic {
    ntfy publish -p 5 alerts --title "Backup failure" --tags error "Cron backups for device $(hostname) failed. You should be panicking. Are you panicking yet?"
}

# This monstrocity is brought to you by backup software refusing to implement backups without encryption.
# Why in the actual fuck would I want encryption when
#   1. The backups are meant to guard against a very specific issue caused by tooling, meaning
#   2. The backups would be stored _in the same place_ as the unencrypted source
# EncRYpTioN is cheap, sure, but it's a pain in the ass to look at what happened or rescue the backups from my NAS without using the CLI if shit goes sideways

backupRepository="/media/NAS/Backups"
#backupRepository="/home/olivia/build/Test folder"
function backup {
    local source=$1
    local shortname=$2
    local dest="${backupRepository}/${shortname}"
    local thisVersion="${dest}/$(date --iso)/"

    mkdir -p "$dest"

    if [[ -d "$thisVersion" ]];
    then
        echo "Panic: $thisVersion already exists. Is Cron misconfigured or delayed?"
        exit -1
    fi

    local lsRes=$(ls -1 "$dest" | sort)
    echo $lsRes
    [[ $? -ne 0 ]] && existing=() || existing=($lsRes)
    
    local size=${#existing[@]}

    echo "Found $size existing backup(s)"

    if [ $size -gt 1 ];
    then
        set -x
        local path="$dest/${existing[0]}"
        if [[ $path == $backupRepository* && path != "/" ]]; then
            rm -rf "$path"
        else
            echo "Panic: $path is out-of-bounds"
            exit -1
        fi
        set +x
    fi
    cp -r "$source" "$thisVersion"
}

# Example:
#     backup /some/path unique-identifier  || panic
# Test backup
#backup $HOME/build/some-folder some-folder || panic
