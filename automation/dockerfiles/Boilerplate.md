# Boilerplate commands 
## Web services
```
# Variables need to be proxied
sudo HOMELAB_DOMAIN=${HOMELAB_DOMAIN} docker compose -f ./docker-compose-vaultwarden.yml up -d
```

## P2P/utility
```
# NOTE: Must be moved out of the 
sudo docker compose -f ./docker-compose-torrent.yml up -d
```

## Updating containers

```
# Called once per update 
sudo docker compose pull
# Called once for each docker compose file
sudo docker compose -f ./{container} up --force-recreate --build -d
# Called once after the update 
sudo docker image prune -f
```
