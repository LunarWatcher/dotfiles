#!/usr/bin/bash

BASE_DIR=${DOTFILES_HOME}

function updateDockerCompose() {
    echo "Preparing to update $1"
    cd $2
    FILE_FLAG=${3:+-f $3}

    sudo -E docker compose $FILE_FLAG pull
    sudo -E docker compose $FILE_FLAG up --force-recreate --build -d
    echo "Updated $1"
}

function scriptedUpdate() {
    echo "Preparing to update $1"
    cd $BASE_DIR
    ./automation/homelab/$2

    echo "Updated $1"
}

function cleanup() {
    sudo docker image prune -f
}
# Docker services {{{
updateDockerCompose "QBitTorrent" /home/olivia/docker/qbittorrent
updateDockerCompose "Penpot" /home/olivia/docker/penpot
updateDockerCompose "ArchiveBox" /home/olivia/docker docker-compose-archivebox.yml
updateDockerCompose "VaultWarden" /home/olivia/programming/dotfiles/automation/dockerfiles docker-compose-vaultwarden.yml
updateDockerCompose "Wekan" /opt/wekan
# }}}
# Non-docker, externally scripted services {{{
scriptedUpdate "Baikal" baikal.sh
scriptedUpdate "Uptime Kuma" uptime-kuma.sh

# }}}
# Non-docker, non-scripted services {{{

function updateForgejo() {
    echo "Updating forgejo"
    
    FORGEJO_VERSION=$(git ls-remote --tags --sort="v:refname" https://codeberg.org/forgejo/forgejo 'v*.*.*' | grep -v -- '-dev$' | tail --lines=1 | cut --delimiter='/' --fields=3)
    FORGEJO_VERSION_NOPREFIX=${FORGEJO_VERSION#v}

    CURR_VERSION=$(curl https://git.$HOMELAB_DOMAIN/api/v1/version -H "Accept: application/json" | jq .version)

    if [[ "$CURR_VERSION" == "$FORGEJO_VERSION*" ]]; then
        echo "Forgejo is already up to date"
        return
    fi

    FORGEJO_PACKAGE=forgejo-${FORGEJO_VERSION_NOPREFIX}-linux-amd64

    wget https://codeberg.org/forgejo/forgejo/releases/download/v${FORGEJO_VERSION_NOPREFIX}/${FORGEJO_PACKAGE}
    chmod +x ${FORGEJO_PACKAGE}
    sudo mv ${FORGEJO_PACKAGE} /usr/local/bin/forgejo
    sudo chmod 755 /usr/local/bin/forgejo
    sudo chown root:root /usr/local/bin/forgejo

    sudo systemctl daemon-reload
    sudo systemctl restart forgejo
    echo "Updated forgejo"
}

updateForgejo 
# }}}



cleanup
