#!/usr/bin/bash

check_ip() {
    response=$(dig "$HOMELAB_DOMAIN" A @9.9.9.9 +noall +answer +short)
    echo "dig says A=$response"
    if [[ "$response" == "" ]]; then
        echo "ddclient is fucked"
        return 1
    fi
}

if ! check_ip; then
    echo "unfucking ddclient"
    sudo ddclient -force

    # Done purely for logging, I don't know what's useful to have here. If ddclient fucks the IP, and I'm not at home,
    # the ntfy server (currently; still need to get it replaced now that ntfy is AI slop) cannot be reached, so I would
    # not be able to see it. I also wouldn't be able to do anything about it even if I did get it, unless I happen to
    # have a copy of the last known IP and it didn't change.
    # I doubt this will fail though, and if it does, it'll re-unfuck itself on the next execution.
    check_ip
else
    echo "No action needed"
fi

