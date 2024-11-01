#!/usr/bin/bash

base_addr=${QBT_ADDR:-localhost}
torrent_addr="$base_addr:8080"

port=$(curl --silent http://$base_addr:8000/v1/openvpn/portforwarded | jq .port)
if [[ "$?" != "0" ]]; then
    ntfy pub --tags fire -p 5 --title="Cron failure [Gluetun]" alerts "Gluetun appears to be dead"
    exit -1
fi

echo "Found port $port. Refreshing qbittorrent..."

curl --fail --silent --show-error \
    --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt \
    --header "Referer: http://$torrent_addr" --data "username=$QBT_USERNAME" --data "password=$QBT_PASSWORD" \
    http://$torrent_addr/api/v2/auth/login 1> /dev/null

listen_port=$(curl --fail --silent --show-error -v --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt http://$torrent_addr/api/v2/app/preferences | jq .listen_port)

if [ ! "$listen_port" ]; then
    ntfy pub --tags fire -p 5 --title "Cron failure [Gluetun]" alerts "Failed to get port from qbittorrent"
    exit 1
fi

# Not sure if this matters in practice, but I set qbittorrent to update the tracker when the port changes, so... maybe reduces unnecessary traffic?
if [ "$port" = "$listen_port" ]; then
    exit 0
fi

echo "Updating port to $port"

curl --fail --silent --show-error --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt  \
    --data-urlencode "json={\"listen_port\": $port}"  http://$torrent_addr/api/v2/app/setPreferences

rm /tmp/cookies.txt
