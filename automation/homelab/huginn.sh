#!/usr/bin/bash

if [ -d /opt/huginn ]; then

    exit 0
fi
# As far as software I've written wrapper scripts around, this is probably the most extreme
# case I've had to deal  with. It wouldn't kill them to add a script to automate this.
# Deps and boilerplate {{{
cd /opt
sudo mkdir huginn

sudo apt-get install -y runit build-essential git zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev logrotate pkg-config cmake nodejs graphviz jq shared-mime-info
sudo apt-get install -y runit-systemd
# }}}
# User and permission management {{{
sudo adduser --disabled-login --gecos 'Huginn' huginn
sudo chown -R huginn huginn
sudo -u huginn git clone https://github.com/huginn/huginn
cd huginn
# }}}
# Ruby deps {{{
sudo gem update --system --no-document
sudo gem install foreman --no-document
# }}}
# DB management {{{
# PSQL should be installed by the makefile prior to this point. If not, fuck you future me,
# cope
sudo -u postgres -H createuser -P huginn
sudo -u postgres -H createdb -O huginn -T template0 huginn_production
# }}}
# Various boilerplate the docs endorses {{{
sudo -u huginn mkdir -p log tmp/pids tmp/sockets
sudo chown -R huginn log/ tmp/
sudo chmod -R u+rwX,go-w log/ tmp/
sudo chmod -R u+rwX,go-w log/
sudo chmod -R u+rwX tmp/
sudo -u huginn -H chmod o-rwx .env

# }}}
# Config {{{
# Both of these might be backup candidates, but I think I'll manage them separately after .
# They're sensitive, so can't post them publicly, so they'd have to be stored on my NAS or something
sudo -u huginn -H cp config/unicorn.rb.example config/unicorn.rb
sudo -u huginn -H cp .env.example .env

# The unicorn.rb config file does not really need attention. Performance is not a concern,
# I'm not deploying extremely performance sensitive for the time being anyway. And if I do,
# this particular file can be hardcoded
#sudo -u huginn vim config/unicorn.rb
sudo -u huginn vim .env
# }}}
# More ruby fun {{{
sudo -u huginn -H bundle install --deployment --without development test
sudo -u huginn -H bundle exec rake db:create RAILS_ENV=production

# Migrate to the latest version
sudo -u huginn -H bundle exec rake db:migrate RAILS_ENV=production

# Create admin user and example agents using the default admin/password login
sudo -u huginn -H bundle exec rake db:seed RAILS_ENV=production SEED_USERNAME=admin SEED_PASSWORD=password
sudo -u huginn -H bundle exec rake assets:precompile RAILS_ENV=production
# }}}
# Procfile fun {{{
# sudo -u huginn -H editor Procfile
# The docs calls for an editor, but fuck that shit, it's massively overcomplicated as written anyway
sudo -u huginn cat <<'EOF' | sudo -u huginn tee /opt/huginn/Procfile
web: bundle exec unicorn -c config/unicorn.rb
jobs: bundle exec rails runner bin/threaded.rb
EOF
# }}}
sudo bundle exec rake production:export
sudo cp deployment/logrotate/huginn /etc/logrotate.d/huginn
sudo bundle exec rake production:status

# Modified from the example: https://github.com/huginn/huginn/blob/master/doc/deployment/nginx/production.conf
# Notable changes:
# 1. conf.d instead of enabled-sites; see https://serverfault.com/a/870709/569995
# 2. Dropped a _lot_ of boilerplate crap that doesn't make sense for a site config to have (it's part of 
#   my global config file instead)
# 3. Paths and other local changes
sudo cat <<'EOF' | sudo tee /opt/nginx/conf.d/huginn.conf
# TODO: is there a good reason this can't be inlined?
upstream huginn_app_server {
    # fail_timeout=0 means we always retry an upstream even if it failed
    # to return a good HTTP response (in case the Unicorn master nukes a
    # single worker for timing out).

    # for UNIX domain socket setups:
    server unix:/home/you/app/shared/pids/unicorn.socket;
}

server {
    listen 443 ssl;

    ssl_certificate         /etc/nova/nova.cert;
    ssl_certificate_key     /etc/nova/nova.key;
  
    client_max_body_size 4G;
    server_name huginn.nova.lan;
    allow 192.168.0.0/24;
    allow 10.0.0.0/8;
    deny all;

    keepalive_timeout 5;

    # path for static files
    root /opt/huginn/app/current/public;

    try_files $uri/index.html $uri.html $uri @app;

    # Rails error pages
    error_page 500 502 503 504 /500.html;
    location = /500.html {
      root /opt/huginn/app/current/public;
    }

    location @app {
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Host $http_host;
      proxy_redirect off;
      proxy_pass http://huginn_app_server;
    }
}
EOF

sudo systemctl restart nginx
