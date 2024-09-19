#!/usr/bin/bash

KAVITA_RELEASE="v0.8.2"

sudo mkdir /opt/kavita
sudo chown $USER /opt/kavita
cd /opt/kavita

wget https://github.com/Kareadita/Kavita/releases/download/${KAVITA_RELEASE}/kavita-linux-x64.tar.gz
tar -xzf kavita-linux-x64.tar.gz
rm kavita-linux-x64.tar.gz


mv Kavita Kavita_RenameCache
mv Kavita_RenameCache/* .
chmod +x Kavita

cat <<EOF | sudo tee /etc/systemd/system/kavita.service
[Unit]
Description=Kavita Server
After=network.target
 
[Service]
Type=simple
WorkingDirectory=/opt/kavita
ExecStart=/opt/kavita/Kavita
TimeoutStopSec=20
KillMode=process
Restart=on-failure
 
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable kavita
sudo systemctl start kavita
