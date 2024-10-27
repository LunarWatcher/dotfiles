include make/distros/debian-base.mk

mint-tweaks:
	sudo apt update && sudo apt install -y software-properties-common
	-sudo apt-add-repository universe && sudo apt update
	# Fix lolcat (the apt version is broken)
	sudo apt remove -y lolcat
	sudo apt install -y ruby
	sudo gem install lolcat

mint-home-packages:
	# Flatpak libreoffice is much more up to date 
	sudo apt purge libreoffice* && sudo apt autoremove
	flatpak install flathub org.libreoffice.LibreOffice
	flatpak install -y flathub com.uploadedlobster.peek
	flatpak install -y flathub com.bitwarden.desktop
	flatpak install -y flathub org.kde.krita
	
	sudo apt install qbittorrent
	
	# TODO: maybe add a thing that downloads .debs from releases to upm?
	wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.7.4/obsidian_1.7.4_amd64.deb -O obsidian.deb
	sudo dpkg -i obsidian.deb
	rm obsidian.deb

	wget https://discord.com/api/download?platform=linux&format=deb -O discord.deb
	sudo dpkg -i discord.deb
	rm discord.deb

	sudo mkdir -p /etc/apt/keyrings
	sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
	echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
	sudo apt-get update
	sudo apt-get install -y syncthing

mint-core:
	sudo add-apt-repository ppa:papirus/papirus
	sudo apt update && sudo apt install papirus-icon-theme
	sudo apt install -y texlive-full
	
mint-home-dotfiles:
	ln -sf ${PWD}/.emacs ${HOME}/.emacs

docker:
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $$(. /etc/os-release && echo "$$UBUNTU_CODENAME") stable" | \
		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	
	sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

mint-debloat:
	sudo apt remove -y hexchat hypnotix transmission-gtk simple-scan

mint-autokey:
	sudo apt install -y autokey-gtk
	DOTFILES_CWD=$$(pwd) envsubst < config/autokey/autokey.json > ~/.config/autokey/autokey.json

mint-rofi:
	sudo apt install -y rofi

	mkdir -p ${HOME}/.config/rofi
	mkdir -p ${HOME}/.config/rofi/themes

	ln -sf ${PWD}/config/rofi/config.rasi ${HOME}/.config/rofi/config.rasi
	ln -sf ${PWD}/config/rofi/themes/catppuccin-latte.rasi ${HOME}/.config/rofi/themes/catppuccin-latte.rasi

mint-keybinds:
	dconf load /org/cinnamon/desktop/keybindings/ < cinnamon/keybinds

mint-export:
	dconf dump /org/cinnamon/desktop/keybindings/ > cinnamon/keybinds

HOME_TARGETS += mint-home-packages mint-home-dotfiles
SOFTWARE_TARGETS += mint-tweaks mint-core mint-tweaks docker mint-autokey mint-rofi mint-keybinds
CLEANUP_TARGETS += mint-debloat
EXPORT_TARGETS += mint-export
