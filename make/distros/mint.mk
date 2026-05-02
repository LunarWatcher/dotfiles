include make/distros/debian-base.mk
include make/distros/ubuntu-base.mk

mint-tweaks:
	sudo apt update && sudo apt install -y software-properties-common
	-sudo apt-add-repository universe && sudo apt update

mint-home-packages:
# Flatpak libreoffice is much more up to date 
	sudo apt purge libreoffice* && sudo apt autoremove -y

	flatpak install -y flathub org.libreoffice.LibreOffice

	sudo apt install -y qbittorrent

# TODO: maybe add a thing that downloads .debs from releases to upm?
	curl -L -o obsidian.deb https://github.com/obsidianmd/obsidian-releases/releases/download/v1.10.6/obsidian_1.10.6_amd64.deb
	sudo dpkg -i obsidian.deb
	rm obsidian.deb

# TODO: make this a command
	curl -L -o discord.deb https://discord.com/api/download?platform=linux\&format=deb
	sudo dpkg -i discord.deb
	rm discord.deb

	curl -fsSL https://proton.me/download/pass-cli/install.sh | bash

mint-core:
	sudo add-apt-repository ppa:papirus/papirus
	sudo apt update && sudo apt install papirus-icon-theme

docker:
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $$(. /etc/os-release && echo "$$UBUNTU_CODENAME") stable" | \
		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

mint-debloat:
	sudo apt remove -y hexchat hypnotix transmission-gtk simple-scan

mint-rofi:
	sudo apt install -y rofi

mint-keybinds:
	dconf load /org/cinnamon/desktop/keybindings/ < cinnamon/keybinds

mint-export:
	dconf dump /org/cinnamon/desktop/keybindings/ > cinnamon/keybinds

HOME_TARGETS += mint-home-packages
SOFTWARE_TARGETS += mint-tweaks mint-core mint-tweaks docker mint-autokey mint-rofi mint-keybinds
CLEANUP_TARGETS += mint-debloat
EXPORT_TARGETS += mint-export
