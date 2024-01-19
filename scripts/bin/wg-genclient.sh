#!/bin/zsh

if [[ "$EUID" != "0" ]]; then
    echo "Need to run with root"
    exit -69
fi

local hostname="$1"

if [[ hostname == "" ]]; then
    echo "You need to supply a hostname as the first parameter"
    exit -69
fi
cd /etc/wireguard
umask 077

wg genkey | tee '${hostname}.key' | wg pubkey > '${hostname}'.pub
wg genpsk > '${hostname}.psk'

cat <<EOF | tee -a wg0.conf

[Peer]
PublicKey = $(cat "${hostname}.pub")
PresharedKey = $(cat "${hostname}.psk")
AllowedIPs = 10.100.0.2/32, fd08:4711::2/128
EOF


# reload wireguard
wg syncconf wg0 <(wg-quick strip wg0)

echo "Client config:"
cat <<EOF | tee ${hostname}.conf
[Interface]
Address = 10.100.0.2/32, fd08:4711::2/128
DNS = 192.168.0.179
PrivateKey = $(cat ${hostname}.key)

[Peer]
AllowedIPs = 10.100.0.1/32, fd08:4711::1/128
Endpoint = ${HOMELAB_DOMAIN}:47111
EOF
cat ${hostname}.conf
qrencode -t ansiutf8 < /etc/wireguard/${hostname}.conf
