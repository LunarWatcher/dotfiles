#!/usr/bin/bash

# One of the many reasons I dislike deploying stuff with docker is tht it's an excessive amount of overhead and firewall evasion for
# little to no real benefit.
# The problems I ran into while writing a native install script were caused by significant flaws in the documentation. 
# But behind this docker image, there's a fully functional install process (that I also could've looked at and taken, but that's an aside).
# Instead, they couldn't be bothered to expose native install scripts, because fuck you.
#
# The only reason this looks nicer is because the scripts weren't exposed. Four lines vs. 130 lines sure sounds like an appealing reason
# to use docker, but that's just because those 130 lines are hidden in a dockerfile instead of in well-defined shell scripts. It's a 
# bad excuse programmers make when they can't be arsed to actually put an effort into making their shit installable. _All_ of the database
# stuff could trivially be put in a script, for example. All the ruby install stuff can't, but that's easily evadable by just calling it a
# prerequisite. The config stuff is harder, but it is doable. 
#
# Here's also my personal favourite oversight: the docs calls for .env to be edited before bundle install (and I have no idea if the order
# can be reversed without a problem), but the .env file calls for `rake secret`. `rake secret` refuses to run until `bundle install` has been called
# And the `bundle install` call as defined in the docs fails because missing privileges, so every single statement after that cascade fails.

sudo docker run -p 6905:3000 \
    --name huginn \
    -v /media/NAS/docker-data/huginn:/var/lib/mysql -d \
    ghcr.io/huginn/huginn

sudo cat <<'EOF' | sudo tee /etc/nginx/conf.d/huginn.conf
server {

    listen 443 ssl;
    server_name huginn.nova.lan;
    allow 192.168.0.0/24;
    allow 10.0.0.0/8;
    deny all;
    ssl_certificate         /etc/nova/nova.cert;
    ssl_certificate_key     /etc/nova/nova.key;


    location / {
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   Host $host;
        proxy_pass         http://localhost:6905/;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection "upgrade";
    }
}
EOF
sudo systemctl restart nginx
