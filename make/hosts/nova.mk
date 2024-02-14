nova-uptime-kuma:
	./automation/homelab/uptime-kuma.sh

nova-vpn:
	./automation/homelab/vpn-server.sh

nova-baikal:
	./automation/homelab/baikal.sh

SOFTWARE_TARGETS += nova-uptime-kuma nova-vpn nova-baikal
