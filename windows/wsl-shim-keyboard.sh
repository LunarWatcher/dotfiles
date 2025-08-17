#!/usr/bin/bash

WSL=/mnt/c/Windows/System32/wsl.exe 

$WSL -d Ubuntu --user root --system bash -c "cat /home/wslg/.config/weston.ini" | grep '\[keyboard\]'

if [[ $? != 0 ]]; then
    $WSL -d Ubuntu --user root --system bash -c "echo -e '[keyboard]' >> /home/wslg/.config/weston.ini"
    $WSL -d Ubuntu --user root --system bash -c "echo -e 'keymap_layout=no' >> /home/wslg/.config/weston.ini"
    $WSL -d Ubuntu --user root --system bash -c "echo -e 'keymap_variant=nodeadkeys' >> /home/wslg/.config/weston.ini"
    $WSL -d Ubuntu --user root --system bash -c "pkill -HUP weston"
    echo "Keyboard shimmed and weston assassinated"
else
    echo "Keyboard already shimmed, no action needed"
fi
