# TODO: would plain package installs be better suited as a modification of archinstall?

arch-core:
	sudo pacman -Syu docker

arch-headed-core:
	sudo pacman -Syu rofi remmina libreoffice-fresh flameshot obs-studio renderdoc firefox

arch-home:
	sudo pacman -Syu steam
	sudo pacman -Syu discord

arch-lua:
	cd /tmp/moonbeam && git pull \
		&& mkdir -p build && cd build \
		&& cmake .. -DCMAKE_BUILD_TYPE=Release \
		&& make -j $(nproc) \
		&& sudo make install

HOME_TARGETS += arch-home
SOFTWARE_TARGETS += arch-core arch-lua
NON_SERVER_TARGETS += arch-headed-core
