wsl -d Ubuntu --user root --system bash -c 'echo -e "[keyboard]" >> /home/wslg/.config/weston.ini'
wsl -d Ubuntu --user root --system bash -c 'echo -e "keymap_layout=no" >> /home/wslg/.config/weston.ini'
wsl -d Ubuntu --user root --system bash -c 'echo -e "keymap_variant=nodeadkeys" >> /home/wslg/.config/weston.ini'
# Restart weston so the changes take place
wsl -d Ubuntu --user root --system bash -c 'pkill -HUP weston'
