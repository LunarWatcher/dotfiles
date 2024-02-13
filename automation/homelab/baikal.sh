#!/usr/bin/bash
# This file is based on https://github.com/JsBergbau/BaikalAnleitung?tab=readme-ov-file#einleitung,
# with the obligatory modifications required for automation purposes.
#
# Aside scaffolding changes and flttening 

if [ -d /opt/baikal ]; then
    cd /opt/baikal
    sudo -u www-data git pull
    sudo -u www-data composer install
    sudo systemctl restart nginx

    exit 0
fi

cd /opt
sudo mkdir baikal
sudo chown -R www-data:www-data baikal
sudo apt-get install -y php-fpm php-sqlite3 composer php-xml php-curl

sudo -u www-data git clone https://github.com/sabre-io/Baikal baikal
cd baikal
sudo -u www-data composer install

# Adapted from https://sabre.io/baikal/install/
# See also https://serverfault.com/a/870709/569995
sudo cat <<'EOF' | sudo tee /etc/nginx/conf.d/baikal.conf
server {

    listen 443 ssl;
    server_name caldav.nova.lan;
    allow 192.168.0.0/24;
    allow 10.0.0.0/8;
    deny all;
    ssl_certificate         /etc/nova/nova.cert;
    ssl_certificate_key     /etc/nova/nova.key;

    root /opt/baikal/html;

    index index.php;

    rewrite ^/.well-known/caldav /dav.php redirect;
    rewrite ^/.well-known/carddav /dav.php redirect;

    charset utf-8;

    location ~ /(\.ht|Core|Specific|config) {
        deny all;
        return 404;
    }

    location ~ ^(.+\.php)(.*)$ {
        try_files $fastcgi_script_name =404;
        include        /etc/nginx/fastcgi_params;
        fastcgi_split_path_info  ^(.+\.php)(.*)$;
        fastcgi_pass   unix:/var/run/php/php-fpm.sock;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        fastcgi_param  PATH_INFO        $fastcgi_path_info;
    }
}
EOF
sudo systemctl restart nginx
