export WSL=/mnt/c/Windows/System32/wsl.exe

function wsl() {
    if [[ "$1" == "restart-gui" ]]; then
        $WSL -d Ubuntu --user root --system bash -c "pkill -HUP weston"
    elif [[ "$1" == "proxy" ]]; then
        $WSL $@
    else
        echo "Usage:"
        echo "\twsl [command] [flags]"
        echo
        echo "Commands:"
        echo "\trestart-gui\tRestarts the GUI. You may need to kill anything you had running, as it's mainly the display protocol that dies"
        echo "\tproxy\t\tForwards the command raw to the native WSL executable. See wsl proxy --help for commands."
    fi
}

