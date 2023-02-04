#!/usr/bin/zsh

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

local homelab_devices=(
    sinon shiro
)
local -A DEVICE_GROUPS=(
    [all]="homelab_devices"
)

local -A homelab_local_addr=(
    [sinon]="sinon.lan"
    [shiro]="shiro.lan"
)

local -A homelab_remote_addr=(
    [sinon]="sinon.remote"
    [shiro]="shiro.remote"
)

local -A homelab_fucky_services=(
    [sinon]="boson"
)

local -A homelab_update_commands=(
    [sinon]="pihole -up"
)

local -A homelab_status_commands=(
    [sinon]="systemctl status -n 0 boson && systemctl status -n 0 discord-hooks && systemctl status -n 0 pihole-FTL"
    [shiro]="systemctl status -n 0 comdest"
)

function homelab() {
    if [[ "$1" == "" || "$1" == "help" ]]; then
        echo "Valid commands:"
        echo "\tupdate\t\tUpdate packages"
        echo "\tmaintenace\tUpdate packages and restart"
        echo "\tfuck\t\tRestarts problem services"
        echo "\tstatus\t\tShows uptime"
        echo "\trestart\t\tRestarts all devices"
        return 1
    fi
    typeset -A local ipset=(${(kv)homelab_local_addr})
    if [[ -v HOMELAB_REMOTE ]];
    then
        ipset=${(kv)homelab_remote_addr}
    fi

    group=${2:-all}
    subsetVar=$DEVICE_GROUPS[$group]
    if [[ "$subsetVar" == "" ]];
    then
        echo "This device group (${group}) has not been defined."
        return 1
    fi

    devices=${(P)subsetVar}

    case $1 in

    "update")
        for host in ${(z)devices}; do
            echo "Updating ${host}..."
            local update_extras=$homelab_update_commands[$host]
            if [[ "${update_extras}" != "" ]];
            then
                update_extras="&& ${update_extras}"
            fi

            ssh -t olivia@${ipset[$host]} "sudo apt update && sudo apt upgrade && sudo apt autoremove ${update_extras}"
        done
    ;;
    "restart")
        for host in ${(z)devices}; do
            echo "Restarting $host..."
            ssh -t olivia@${ipset[$host]} "sudo reboot now"
        done
    ;;
    "maintenace")
        homelab update
        homelab restart
    ;;
    "fuck")
        for host in ${(z)devices}; do
            local services=$homelab_fucky_services[$host]
            if [[ "${services}" == "" ]];
            then
                continue
            fi
            echo "Restarting ${services} on $host..."
            ssh olivia@${ipset[$host]} "sudo systemctl restart ${services}"
        done
    ;;
    "status")
        for host in ${(z)devices}; do
            local status_extra=$homelab_status_commands[$host]
            if [[ "${status_extra}" != "" ]];
            then
                status_extra="&& ${status_extra}"
            fi
            ssh olivia@${ipset[$host]} "hostname && uptime && echo '' $status_extra"
        done
    ;;
    *)
        echo "$1 is not a valid command."
        homelab
    ;;
    esac
}
