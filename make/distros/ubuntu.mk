include make/distros/debian-base.mk

ubuntu-autorestic:
	wget -qO - https://raw.githubusercontent.com/cupcakearmy/autorestic/master/install.sh | sudo bash

SERVER_TARGETS += ubuntu-autorestic
