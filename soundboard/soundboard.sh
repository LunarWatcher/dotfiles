#!/usr/bin/env zsh

MIC_UNIT=${MIC_UNIT:-streamplify Mic.}
SOUNDBOARD_DIR=${SOUNDBOARD_DIR:-/home/olivia/Music/Soundboard}

function setupMic() {
    if [ -f /tmp/soundboardMic ]; then
        return 0
    fi

    pactl get-sink-volume soundboard_sink > /dev/null 2>&1

    if [[ "$?" == "0" ]];
    then
        destroyMic
    fi

    pactl load-module module-null-sink sink_name=soundboard_sink rate=44100 sink_properties=device.description=soundboard_sink
    pactl load-module module-loopback rate=44100 source=$(pactl get-default-source) sink=soundboard_sink sink_dont_move=true source_dont_move=true
    pactl load-module module-null-sink sink_name=soundboard_sink_passthrough rate=44100 sink_properties=device.description=soundboard_sink_passthrough
    pactl load-module module-loopback source=soundboard_sink_passthrough.monitor sink=soundboard_sink source_dont_move=true
    pactl load-module module-loopback source=soundboard_sink_passthrough.monitor source_dont_move=true
}

function destroyMic() {
    pactl unload-module module-null-sink
    pactl unload-module module-loopback
}

function playSound() {
    pactl get-sink-volume soundboard_sink > /dev/null 2>&1

    if [[ "$?" != "0" ]];
    then
        setupMic
        pactl get-sink-volume soundboard_sink > /dev/null 2>&1

        if [[ "$?" != "0" ]];
        then
            return -1
        fi
    fi

    paplay ${SOUNDBOARD_DIR%/}/$1 --volume 30000 --device soundboard_sink_passthrough
}

case "$1" in
    play) playSound $2 ;;
    setup) setupMic ;;
    destroy) destroyMic ;;
    *) echo "Error: Invalid argument"; return -1 ;;
esac

# vim:ft=zsh
