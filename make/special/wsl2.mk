wsl-update:
	sudo apt update -y

wsl-packages: wsl-update
	# Fonts
	sudo apt install -y fonts-noto-color-emoji fonts-freefont-otf fonts-freefont-ttf \
		fonts-ubuntu fonts-ubuntu-console fonts-dejavu-core fonts-opensymbol fonts-noto-cjk
	# Theming
	sudo apt install -y gnome-tweaks 

wsl-unfuck-unicode: wsl-update
	sudo apt install -y language-pack-en locales
	sudo update-locale LANG=en_GB.UTF8

DEPENDENCY_TARGETS += wsl-packages wsl-unfuck-unicode
