#!/usr/bin/bash

if [ -d /opt/uptime-kuma ]; then
    cd /opt/uptime-kuma
    git fetch --tags
    latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
    currTag=$(git describe --tags)

    if [[ "$latestTag" == "$currTag" ]]; then
        echo "No updates."
        exit 0
    fi

    git checkout $latestTag

    npm install --production
    npm run download-dist

    sudo systemctl restart uptime-kuma
    exit 0
fi



cd /opt
sudo mkdir uptime-kuma
sudo chown -R $USER uptime-kuma 

git clone https://github.com/louislam/uptime-kuma

cd uptime-kuma
npm run setup

sudo cat <<'EOF' | sudo tee /etc/systemd/system/uptime-kuma.service
[Unit]
Description=Uptime dashboard
Wants=network-online.target
After=network.target

[Service]
Restart=on-failure
RestartSec=60s
Type=idle
WorkingDirectory=/opt/uptime-kuma
Environment="UPTIME_KUMA_PORT=6902"
ExecStart=node server/server.js

[Install]
WantedBy=multi-user.target
EOF
