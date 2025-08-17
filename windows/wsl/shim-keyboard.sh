#!/usr/bin/bash

# X11
setxkbmap no nodeadkeys > /dev/null 2>&1
# Wayland {{{
# I really hope Windows just makes wayland worse than it is in reality.
# Wayland not having standard programs for stuff has made stuff like setting the keyboard
# layout _much_ more difficult than it needed to be.
# It might be easier when sticking to a specific DE, but cross-DE scripting stability
# appears to be absolutely non-existent.

echo "Note: WSL translation failures are expected. This is just Windows being overly shit"
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
# }}}
