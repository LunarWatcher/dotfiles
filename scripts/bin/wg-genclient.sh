#!/bin/zsh

if [[ "$EUID" != "0" ]]; then
    echo "Need to run with root"
    exit -69
fi

if [[ "$HOMELAB_DOMAIN" == "" ]]; then
    echo "HOMELAB_DOMAIN is undefined. If this is wrong, try running sudo -E instead"
    exit -69
fi

local hostname="$1"

if [[ hostname == "" ]]; then
    echo "You need to supply a hostname as the first parameter"
    exit -69
fi
cd /etc/wireguard
umask 077

# This will overflow after 255 clients and break, but I'm never going to have that many clients
# connected to my server, so that's a non-issue
local startIp=2
local peers=$(cat wg0.conf | grep Peer | wc -l)
local ip=$((($startIp + $peers)))

wg genkey | tee "${hostname}.key" | wg pubkey > "${hostname}".pub
wg genpsk > "${hostname}.psk"

cat <<EOF | tee -a wg0.conf
[Peer]
PublicKey = $(cat "${hostname}.pub")
PresharedKey = $(cat "${hostname}.psk")
AllowedIPs = 10.100.0.$ip/32, fd08:4711::$ip/128
EOF


# reload wireguard
wg syncconf wg0 <(wg-quick strip wg0)

echo "\n\n\nClient config:"
cat <<EOF | tee ${hostname}.conf
[Interface]
Address = 10.100.0.$ip/32
Address = fd08:4711::$ip/128
DNS = 192.168.0.179
PrivateKey = $(cat ${hostname}.key)

[Peer]
AllowedIPs = 0.0.0.0/0, ::/0, 192.168.0.0/16
Endpoint = ${HOMELAB_DOMAIN}:47111
PublicKey = $(cat server.pub)
PresharedKey = $(cat ${hostname}.psk)
PersistentKeepalive = 25
EOF
qrencode -t ansiutf8 < ${hostname}.conf
