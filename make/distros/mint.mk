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
	
	# What have I done?
	sudo apt install -y emacs
	sudo apt install qbittorrent

mint-core:
	sudo add-apt-repository ppa:papirus/papirus
	sudo apt update && sudo apt install papirus-icon-theme
	sudo apt install texlive-full
	
mint-home-dotfiles:
	ln -sf ${PWD}/.emacs ${HOME}/.emacs

docker:
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
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
	-rm ${HOME}/.config/rofi/themes/catppuccin-latte.rasi
	wget https://github.com/LunarWatcher/catppuccin-rofi-saucecodepro/raw/refs/heads/main/basic/.local/share/rofi/themes/catppuccin-latte.rasi -P ${HOME}/.config/rofi/themes/

HOME_TARGETS += mint-home-packages mint-home-dotfiles
SOFTWARE_TARGETS += mint-tweaks mint-core mint-tweaks docker mint-autokey mint-rofi
CLEANUP_TARGETS += mint-debloat
