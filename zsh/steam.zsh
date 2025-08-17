#!/usr/bin/zsh
# This script adds certain steam programs to the PATH. These are shown in the
# steam_progs variable
# This is exclusively intended for tools that have CLI applications. 
# (Unrelated, it's so fucking cool that steam, who mostly have games, also 
# have utilities and tools, and that some of these have CLIs)

export STEAM_ROOTS=($(awk -F\" '/"path"/ { print $4 }' ~/.steam/steam/steamapps/libraryfolders.vdf))
local steam_progs=(Aseprite)
for root in $STEAM_ROOTS; do
    for prog in $steam_progs; do
        local PROG_PATH=$root/steamapps/common/$prog
        if [[ -d $PROG_PATH ]]; then
            export PATH="$PROG_PATH:$PATH"
        fi
    done
done
unset PROG_PATH
unset steam_progs
