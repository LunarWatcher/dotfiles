# This file exists because no better options exist.
#
# To properly interact with my network, I need an interactive ssh session.
# This is because I don't allow sshing into root, as this is fucking stupid
# from a security standpoint.
#
# This means tools like ansible are off the table, because it requires a root
# session for shit like updating, which is just idiotic.
#
# This file (and function) contains my alternative to network automation.
# Admittedly, this isn't fully unsupervised; it requires passwords when `sudo`
# is used, because again, sshing into root is fucking stupid and storing passwords
# in plain text is even worse.
function homelab() {
    if [[ "$1" == "" || "$1" == "help" ]]; then
        echo "Valid commands:"
        echo "\tupdate\t\tUpdate packages"
        echo "\tmaintenace\tUpdate packages and restart"
        echo "\tfuck\t\tRestarts problem services"
        echo "\tstatus\t\tShows uptime"
        return 1
    fi
    local shiro=shiro.lan
    local sinon=sinon.lan
    if [[ -v HOMELAB_REMOTE ]];
    then
        echo "Using remote IPs"
        shiro=shiro.remote
        sinon=sinon.remote
    fi

    case $1 in

    "update")
        echo "Updating sinon..."
        ssh -t olivia@${sinon} "sudo apt update && sudo apt upgrade && sudo pihole -up"
        echo "Updating shiro..."
        ssh -t olivia@${sinon} "sudo apt update && sudo apt upgrade"
    ;;
    "maintenace")
        homelab update
        ssh -t olivia@${sinon} "sudo reboot now"
        ssh -t olivia@${shiro} "sudo reboot now"
    ;;
    "fuck")
        ssh olivia@${sinon} "sudo systemctl restart boson"
    ;;
    "status")
        ssh olivia@${sinon} "hostname && uptime && echo '' && systemctl status -n 0 boson && systemctl status -n 0 discord-hooks && systemctl status -n 0 pihole-FTL"
        ssh olivia@${shiro} "hostname && uptime && echo '' && systemctl status -n 0 comdest"
    ;;
    *)
        echo "$1 is not a valid command."
        homelab
    ;;
    esac
}
