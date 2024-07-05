nova-uptime-kuma:
	./automation/homelab/uptime-kuma.sh

nova-vpn:
	./automation/homelab/vpn-server.sh

nova-baikal:
	./automation/homelab/baikal.sh

nova-certbot:
	sudo mkdir -p /opt/certbot
	-sudo python3 -m venv /opt/certbot
	-sudo /opt/certbot/bin/pip install certbot certbot-dns-desec
	-sudo ln -s /opt/certbot/bin/certbot /usr/local/bin/certbot

	# Updating and renewal
	echo '0 12 */10 * * root /opt/certbot/bin/pip install --upgrade certbot || ntfy pub alerts --tags fire -p 5 "Certbot update failed"' | sudo tee /etc/cron.d/certbot
	echo '0 0,12 * * * root /opt/certbot/bin/python -c "import random; import time; time.sleep(random.random() * 3600)" && sudo certbot renew -q || ntfy pub alerts --tags fire -p 5 "Certbot renewal failed"' | sudo tee -a /etc/cron.d/certbot

SOFTWARE_TARGETS += nova-uptime-kuma nova-vpn nova-baikal nova-certbot
