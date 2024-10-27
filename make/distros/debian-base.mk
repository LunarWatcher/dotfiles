debian-build-deps:
	@echo "Installing general build dependencies..."
	sudo apt install -y autoconf automake autotools-dev build-essential \
		libjansson-dev libtool libtool-bin cmake pkg-config \
		git wget curl libssl-dev cargo xclip nano python3-pkg-resources \
		libncurses-dev libgtk-3-dev libxt-dev libpython3-dev \
		apt-transport-https
	@echo "Done."

debian-base-update:
	sudo apt update && sudo apt upgrade -y

debian-vim-deps:
	# TODO: This should really be an OS distro thing
	sudo apt install -y latexmk universal-ctags

ohmyzsh:
	-[ ! -d "$${HOME}/.oh-my-zsh" ] && curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
	-zsh -c 'source ~/.zshrc; git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $${ZSH_CUSTOM}/themes/powerlevel10k'

debian-dotfile-software: debian-vim-deps ohmyzsh
	sudo apt -y install tmux zsh silversearcher-ag
	

config:
	rsync -av --progress config/ ~/.config/

debian-base-dotfiles: config
	ln -sf ${PWD}/.zshrc ${HOME}/.zshrc
	ln -sf ${PWD}/.shell_aliases ${HOME}/.shell_aliases
	ln -sf ${PWD}/.p10k.zsh ${HOME}/.p10k.zsh
	ln -sf ${PWD}/.tmux.conf ${HOME}/.tmux.conf

debian-home-packages:
	# Installs Steam
	wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb && sudo apt install -y ./steam.deb

	# Spotify
	curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt-get update && sudo apt-get install -y spotify-client

	sudo apt install -y golang
	-go install github.com/boyter/scc@latest

debian-core:
	wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/SauceCodeProNerdFont-Regular.ttf -O "Sauce Code Pro Nerd Font Complete.ttf"
	# Needed for gnome terminal because reasons
	wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/SauceCodeProNerdFontMono-Regular.ttf -O "Sauce Code Pro Nerd Font Complete Mono.ttf"
	sudo mv "Sauce Code Pro Nerd Font Complete.ttf" /usr/local/share/fonts
	sudo mv "Sauce Code Pro Nerd Font Complete Mono.ttf" /usr/local/share/fonts
	sudo fc-cache -f
	
	sudo apt install -y plocate
	# Mainly used for mobile wireguard on my server, but it does have some interesting general applications
	sudo apt install -y qrencode
	
	-[ ! -d "$${HOME}/.pyenv" ] && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
	
	# Neofetch has been archived
	# sudo apt install -y fastfetch
	
	sudo apt install -y python3-venv

vim:
	sudo bash -c "$$(wget -O- https://raw.githubusercontent.com/LunarWatcher/upm/master/tools/install.sh)"

DEPENDENCY_TARGETS += debian-base-update debian-build-deps debian-dotfile-software
DOTFILE_TARGETS += debian-base-dotfiles
SOFTWARE_TARGETS += debian-core vim
