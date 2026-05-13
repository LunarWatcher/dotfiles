debian-build-deps:
	@echo "Installing general build dependencies..."
	sudo apt install -y autoconf automake autotools-dev build-essential \
		libjansson-dev libtool libtool-bin cmake pkg-config \
		git wget curl libcurlpp-dev libssl-dev cargo xclip nano python3-pkg-resources \
		libncurses-dev libgtk-3-dev libxt-dev libpython3-dev \
		apt-transport-https meson
	@echo "Done."

debian-base-update:
	sudo apt update && sudo apt upgrade -y

debian-vim-deps:
# TODO: This should really be an OS distro thing
	sudo apt install -y universal-ctags


debian-dotfile-software: debian-vim-deps
	sudo apt -y install zsh silversearcher-ag ripgrep jq golang

	curl -fsSL https://deno.land/install.sh | sh

debian-home-packages:
# Steam
	wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb && sudo apt install -y ./steam.deb

# Spotify
	curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt-get update && sudo apt-get install -y spotify-client

	sudo apt install -y golang sshfs
	-go install github.com/boyter/scc@latest


debian-core:
	wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/SauceCodeProNerdFont-Regular.ttf -O "Sauce Code Pro Nerd Font Complete.ttf"
	wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/SauceCodeProNerdFont-Bold.ttf -O "Sauce Code Pro Nerd Font Complete Bold.ttf"
	wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/SauceCodeProNerdFont-Italic.ttf -O "Sauce Code Pro Nerd Font Complete Italic.ttf"
# Needed for gnome terminal because reasons (TODO: not anymore?)
	wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/SauceCodeProNerdFontMono-Regular.ttf -O "Sauce Code Pro Nerd Font Complete Mono.ttf"
	sudo mv "Sauce Code Pro Nerd Font Complete.ttf" /usr/local/share/fonts
	sudo mv "Sauce Code Pro Nerd Font Complete Bold.ttf" /usr/local/share/fonts
	sudo mv "Sauce Code Pro Nerd Font Complete Italic.ttf" /usr/local/share/fonts
	sudo mv "Sauce Code Pro Nerd Font Complete Mono.ttf" /usr/local/share/fonts
	sudo fc-cache -f

	sudo apt install -y plocate
# Mainly used for mobile wireguard on my server, but it does have some interesting general applications
	sudo apt install -y qrencode

# Neofetch has been archived, fastfetch is not available by default
# TODO when I can be bothered, add the fastfetch ppa
# sudo apt install -y fastfetch

	sudo apt install -y python3-venv
	sudo apt install -y extrepo

# Only used by certain tools
# TODO: install with all defaults without requiring interaction
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | RUSTUP_INIT_SKIP_PATH_CHECK=yes sh
	$${HOME}/.cargo/bin/cargo install zellij

# Largely used by stripped-down distros
	sudo apt install -y zip 7zip

zsh-deps: debian-base-update
	git clone https://codeberg.org/LunarWatcher/amethyst ~/.config/amethyst

node: upm
	sudo upm install nodejs

dev-support: debian-core
	sudo apt install -y direnv

debian-lua:
	sudo apt install lua5.4 liblua5.4-dev
	-git clone https://codeberg.org/LunarWatcher/moonbeam /tmp/moonbeam
	cd /tmp/moonbeam && git pull \
		&& mkdir -p build && cd build \
		&& cmake .. -DCMAKE_BUILD_TYPE=Release \
		&& make -j $(nproc) \
		&& sudo make install

DEPENDENCY_TARGETS += debian-base-update debian-build-deps zsh-deps debian-dotfile-software debian-lua
DOTFILE_TARGETS += debian-base-dotfiles
SOFTWARE_TARGETS += debian-core node dev-support
HOME_TARGETS += debian-home-packages
