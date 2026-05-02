# TODO: would plain package installs be better suited as a modification of archinstall?


arch-core:
	pacman -Syu docker

arch-headed-core:
	pacman -Syu rofi remmina libreoffice-fresh flameshot obs-studio renderdoc firefox

arch-home:
	pacman -Syu steam
	pacman -Syu discord


HOME_TARGETS += arch-home
SOFTWARE_TARGETS += arch-core
NON_SERVER_TARGETS += arch-headed-core
