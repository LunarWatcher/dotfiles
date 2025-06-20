#!/usr/bin/zsh

# Variable declarations {{{
local homelab_devices=(
    sinon nova
)
local -A device_groups=(
    [all]="homelab_devices"
)

local -A homelab_local_addr=(
    [sinon]="sinon"
    [nova]="nova"
)

local -A homelab_remote_addr=(
    [sinon]="sinon.remote"
    [nova]="nova.remote"
)

local -A homelab_fucky_services=(
    [sinon]="boson"
)

local -A homelab_update_commands=(
    [sinon]="sudo pihole -up"
)

local -A homelab_status_commands=(
    [sinon]="systemctl status -n 0 boson && systemctl status -n 0 discord-hooks && systemctl status -n 0 pihole-FTL"
    [nova]="systemctl status -n 0 comdest"
)
# }}}

function homelab() {
    # Help command; short-circuited to avoid unnecessary processing {{{
    if [[ "$1" == "" || "$1" == "help" ]]; then
        echo "Valid commands:"
        echo "\tupdate\t\tUpdate packages"
        echo "\tmaintenance\tUpdate packages and restart"
        echo "\tfuck\t\tRestarts problem services"
        echo "\tstatus\t\tShows uptime"
        echo "\trestart\t\tRestarts all devices"
        return 1
    fi
    # }}}
    # This is a mouthful
    #
    # First, resolve the IP set
    local -A ipset=(${(kv)homelab_local_addr})
    if [[ -v HOMELAB_REMOTE ]];
    then
        # if HOMELAB_REMOTE has been set, use the remote address system instead.
        ipset=${(kv)homelab_remote_addr}
    fi

    # Get the group
    group=${2:-all}
    # Check if the group exists
    subsetVar=$device_groups[$group]
    if [[ "$subsetVar" == "" ]];
    then
        # If not, check if a device matches
        if [[ ${homelab_devices[(r)$group]} == $group ]];
        then
            devices=($group)
        else
            echo "This device group (${group}) has not been defined, and can't be resolved to be a specific device."
            return 1
        fi
    else
        # Otherwise, set devices to the expanded variable retrieved from device_groups
        # This is necessary because nested arrays aren't a thing
        devices=${(P)subsetVar}
    fi


    # Command procesing
    case $1 in

        "update") # {{{
            for host in ${(z)devices}; do
                echo "Updating ${host}..."
                local update_extras=$homelab_update_commands[$host]
                if [[ "${update_extras}" != "" ]];
                then
                    update_extras="&& ${update_extras}"
                fi

                ssh -t olivia@${ipset[$host]} "sudo apt update && sudo apt upgrade && sudo apt autoremove ${update_extras}"
            done
        ;; # }}}
        "restart") # {{{
            for host in ${(z)devices}; do
                echo "Restarting $host..."
                ssh -t olivia@${ipset[$host]} "sudo reboot now"
            done
        ;; # }}}
        "maintenance") # {{{
            homelab update
            homelab restart
        ;; # }}}
        "fuck") # {{{
            for host in ${(z)devices}; do
                local services=$homelab_fucky_services[$host]
                if [[ "${services}" == "" ]];
                then
                    continue
                fi
                echo "Restarting ${services} on $host..."
                ssh olivia@${ipset[$host]} "sudo systemctl restart ${services}"
            done
        ;; # }}}
        "status") # {{{
            for host in ${(z)devices}; do
                local status_extra=$homelab_status_commands[$host]
                if [[ "${status_extra}" != "" ]];
                then
                    status_extra="&& ${status_extra}"
                fi
                ssh olivia@${ipset[$host]} "hostname && uptime && echo '' $status_extra"
            done
        ;; # }}}
        *) # {{{
            echo "$1 is not a valid command."
            homelab
            return 0
        ;; # }}}
    esac
}
