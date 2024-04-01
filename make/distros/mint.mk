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

mint-core:
	sudo add-apt-repository ppa:papirus/papirus
	sudo apt update && sudo apt install papirus-icon-theme
	sudo apt install texlive-full
	
mint-home-dotfiles:
	ln -sf ${PWD}/.emacs ${HOME}/.emacs

mint-debloat:
	sudo apt remove -y hexchat hypnotix transmission-gtk simple-scan

HOME_TARGETS += mint-home-packages mint-home-dotfiles
SOFTWARE_TARGETS += mint-tweaks mint-core mint-tweaks
CLEANUP_TARGETS += mint-debloat
