#!/usr/bin/bash

function updateDockerCompose() {
    echo "Preparing to update $1"
    cd $2
    FILE_FLAG=${3:+-f $3}

    sudo -E docker compose $FILE_FLAG pull
    sudo -E docker compose $FILE_FLAG up --force-recreate --build -d
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

# }}}



cleanup
