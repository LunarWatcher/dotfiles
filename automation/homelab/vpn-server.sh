#!/usr/bin/bash

sudo apt install -y wireguard wireguard-tools

# Check if the config file exists
# Note that sudo bash -c is used as root privs are required to even cd into /etc/wireguard
sudo bash -c "[[ -e /etc/wireguard/wg0.conf ]] || exit -1"

if [ "$?" -eq "0" ]; then
    echo "Wireguard already initialised. Skipping"
else
    # Wireguard has not been initialised. Run elementary setup

    # https://docs.pi-hole.net/guides/vpn/wireguard/server/#initial-configuration
    sudo bash -c "cd /etc/wireguard && umask 077"
    sudo bash -c "cd /etc/wireguard && wg genkey | tee server.key | wg pubkey > server.pub"
    
    sudo cat <<EOF | sudo tee /etc/wireguard/wg0.conf
[Interface]
Address = 10.100.0.1/24, fd08:4711::1/64, 192.168.0.170, 192.168.0.179
ListenPort = 47111
PrivateKey = $(sudo cat /etc/wireguard/server.key)
EOF

    sudo systemctl enable wg-quick@wg0.service
    sudo systemctl daemon-reload
    sudo systemctl start wg-quick@wg0
fi
