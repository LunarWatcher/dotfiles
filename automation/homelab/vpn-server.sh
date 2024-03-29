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
Address = 10.100.0.1/24
Address = fd08:4711::1/64
ListenPort = 47111
PrivateKey = $(sudo cat /etc/wireguard/server.key)
PostUp = ufw route allow in on wg0 out on eno1
PostUp = iptables -t nat -I POSTROUTING -o eno1 -j MASQUERADE
PostUp = ip6tables -t nat -I POSTROUTING -o eno1 -j MASQUERADE
PreDown = ufw route delete allow in on wg0 out on eno1
PreDown = iptables -t nat -D POSTROUTING -o eno1 -j MASQUERADE
PreDown = ip6tables -t nat -D POSTROUTING -o eno1 -j MASQUERADE
EOF

    sudo ufw allow 47111
    sudo systemctl enable wg-quick@wg0.service
    sudo systemctl daemon-reload
    sudo systemctl start wg-quick@wg0
fi
