#!/usr/bin/bash

# Not sure if git-lfs is installed alongside git
sudo apt install git git-lfs

FORGEJO_VERSION=${FORGEJO_VERSION:-9.0.1}

wget https://codeberg.org/forgejo/forgejo/releases/download/v${FORGEJO_VERSION}/forgejo-${FORGEJO_VERSION}-linux-amd64
sudo mv forgejo-${FORGEJO_VERSION}-linux-amd64 /usr/local/bin/forgejo
sudo chmod 755 /usr/local/bin/forgejo

grep "^git:" /etc/passwd

if [[ "$?" == "0" ]]; then
    exit 0
fi
# No git user means nothing else has been set up.
cat <<'EOF' | sudo tee /etc/systemd/system/forgejo.service
[Unit]
Description=Forgejo (Beyond coding. We forge.)
After=syslog.target
After=network.target
#Wants=postgresql.service
#After=postgresql.service

[Service]
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/forgejo/
ExecStart=/usr/local/bin/forgejo web --config /etc/forgejo/app.ini
Restart=always
Environment=USER=git HOME=/home/git FORGEJO_WORK_DIR=/var/lib/forgejo

[Install]
WantedBy=multi-user.target
EOF

sudo cat <<'EOF' | envsubst | sudo tee /etc/nginx/conf.d/forgejo.conf
server {

    listen 443 ssl;
    server_name git.$BASE_DOMAIN;

    ssl_certificate         /etc/letsencrypt/live/$BASE_DOMAIN/fullchain.pem;
    ssl_certificate_key     /etc/letsencrypt/live/$BASE_DOMAIN/privkey.pem;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto https;
        proxy_pass http://localhost:3000;
    }
}
EOF

sudo adduser --system --shell /bin/bash --gecos 'Git Version Control' \
  --group --disabled-password --home /home/git git

sudo mkdir /var/lib/forgejo
sudo chown git:git /var/lib/forgejo && chmod 750 /var/lib/forgejo
sudo mkdir /etc/forgejo
sudo chown root:git /etc/forgejo && chmod 770 /etc/forgejo

sudo systemctl enable forgejo.service
sudo systemctl start forgejo.service
