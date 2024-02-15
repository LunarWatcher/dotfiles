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
        fastcgi_param  QUERY_STRING       $query_string;
        fastcgi_param  REQUEST_METHOD     $request_method;
        fastcgi_param  CONTENT_TYPE       $content_type;
        fastcgi_param  CONTENT_LENGTH     $content_length;

        fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
        fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
        fastcgi_param  REQUEST_URI        $request_uri;
        fastcgi_param  DOCUMENT_URI       $document_uri;
        fastcgi_param  DOCUMENT_ROOT      $document_root;
        fastcgi_param  SERVER_PROTOCOL    $server_protocol;
        fastcgi_param  REQUEST_SCHEME     $scheme;
        fastcgi_param  HTTPS              $https if_not_empty;

        fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
        fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;

        fastcgi_param  REMOTE_ADDR        $remote_addr;
        fastcgi_param  REMOTE_PORT        $remote_port;
        fastcgi_param  REMOTE_USER        $remote_user;
        fastcgi_param  SERVER_ADDR        $server_addr;
        fastcgi_param  SERVER_PORT        $server_port;
        fastcgi_param  SERVER_NAME        $server_name;

        # PHP only, required if PHP was built with --enable-force-cgi-redirect
        fastcgi_param  REDIRECT_STATUS    200;
        fastcgi_split_path_info  ^(.+\.php)(.*)$;
        fastcgi_pass   unix:/var/run/php/php-fpm.sock;
        fastcgi_param  PATH_INFO        $fastcgi_path_info;
    }
}
EOF
sudo systemctl restart nginx
