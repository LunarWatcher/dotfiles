# TODO: would plain package installs be better suited as a modification of archinstall?

arch-core:
	sudo pacman -Syu docker

arch-headed-core:
	sudo pacman -Syu rofi remmina libreoffice-fresh flameshot obs-studio renderdoc firefox

arch-home:
	sudo pacman -Syu steam
	sudo pacman -Syu discord

arch-yay:
	cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

HOME_TARGETS += arch-home
SOFTWARE_TARGETS += arch-core arch-yay
NON_SERVER_TARGETS += arch-headed-core
