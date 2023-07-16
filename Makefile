update:
	sudo apt update && sudo apt upgrade -y

build-deps:
	@echo "Installing general build dependencies..."
	sudo apt install -y autoconf automake autotools-dev build-essential \
		libjansson-dev libtool libtool-bin cmake pkg-config
	@echo "Done."

vim-build-deps: # Grabs Vim build dependencies
	@echo "Installing dependencies for the Vim build..."
	# This contains potentially redundant packages
	-sudo apt install -y libncurses5-dev \
		libgtk-3-dev libatk1.0-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev python3-dev \
		ruby-dev lua5.3 liblua5.3-dev luajit libluajit-5.1-dev libperl-dev
	# Caveat; if Vim still fails to compile lua, run:
	# cd /usr/include && ln -s lua5.1 lua
	# Vim is very specific about the file location :rolling_eyes:
	# --with-lua-prefix doesn't work without a few hacks with symlinks,
	#  because it's a prefix and not a location.
	#  It searches in include/ and include/lua in the path supplied
	@echo "Done"

packages: # Install base packages
	@echo "Installing packages..."
	sudo apt update && sudo apt install -y software-properties-common
	-sudo apt-add-repository universe && sudo apt update
	# Fix lolcat (the apt version is broken)
	sudo apt remove -y lolcat
	sudo apt install -y ruby
	sudo gem install lolcat
	# My condolences future me, I tried to avoid it.
	# But turns out CoC is actually good now, and that requires node, soooo
	# Don't get rekt in the future pl0x
	#sudo apt install -y npm nodejs
	# ---
	# Hi past me. Fuck you.
	# This fucking crap broke because coc.nvim requires node 12 or higher, while
	# Mint ships with fucking 10.xx. This shit was outdated ages ago.
	# ugh, thanks for nothing. Use upm: https://github.com/lunarwatcher/upm
	# Currently requires a manual install because I work on it, but for anyone else
	# who runs into this, you need to update npm and node manually. Blame Ubuntu
	#
	# Even then this does not change that node and npm are required for now.
	# Seems it's unavoidable for uni, though, so will see what I can do with upm.
	# Auto-installing it along with dependencies should help a little
	
	# Install general stuff
	sudo apt install -y git thefuck curl python-pkg-resources libssl-dev \
		wget nano xclip tmux cargo
	
	# TODO: clang 12
	# C++ dev stuff
	sudo apt install -y clang-12 clang-format-12
	# Install build dependencies
	make build-deps
	
	@echo "Done".

theming:
	sudo add-apt-repository ppa:papirus/papirus
	sudo apt update && sudo apt install papirus-icon-theme

tmux:
	mkdir -p ~/.tmux
	-git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

home-packages:
	bash -c '[[ "$$(lsb_release -i)" =~ "Linuxmint" ]] && sudo apt remove hexchat hypnotix transmission-gtk simple-scan'
	# Installs home packages.
	# These are definitely _not_ barebone packages, and extend beyond basic use.
	# The version of LibreOffice that ships with Mint is _ancient_. The FlatHub variant
	# is officially endorsed, it's a _lot_ newer, a lot faster, and a lot prettier
	sudo apt purge libreoffice* && sudo apt autoremove
	flatpak install flathub org.libreoffice.LibreOffice

	# Installs Steam
	wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb && sudo apt install -y ./steam.deb
	
additional-packages:
	# installs peek (gif screen recorder)
	flatpak install -y flathub com.uploadedlobster.peek

	flatpak install -y flathub com.bitwarden.desktop
	flatpak install -y flathub org.kde.krita

	# Installs ksnip for its editing capabilities
	wget https://github.com/ksnip/ksnip/releases/download/v1.7.1/ksnip-1.7.1.deb && sudo apt install -y ./ksnip-1.7.1.deb

	# Spotify
	curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt-get update && sudo apt-get install -y spotify-client

pythoninstall:
	-[ ! -d "$${HOME}/.pyenv" ] && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

goinstall:
	sudo apt install -y golang
	-go install github.com/boyter/scc@latest

zsh: # Installs zsh and oh-my-zsh
	# Install the shell
	sudo apt install -y zsh
	
	-curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
	make powerlevel
	# Install zsh syntax highlighting
	#zsh -c 'source ~/.zshrc; git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'

powerlevel:
	-zsh -c 'source ~/.zshrc; git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $${ZSH_CUSTOM}/themes/powerlevel10k'

server-essentials:
	sudo apt install mlocate 

# TODO: replace with upm
vim:
	@echo "Building Vim..."
	make vim-build-deps
	-git clone https://github.com/vim/vim.git
	cd vim/src && \
		./configure --enable-gui=gtk3 --with-features=huge --enable-multibyte \
			--enable-rubyinterp=yes --enable-python3interp=yes \
			--enable-perlinterp=yes --enable-luainterp=yes --with-luajit=yes \
			--enable-cscope --prefix=/usr/local \
			--enable-largefile --enable-fail-if-missing --with-compiledby="Olivia" && \
		make -j $$(nproc) && \
		sudo make install
	rm -rf vim
	@echo "Done"

install-vim-plug: # Installs junegunn/vim-plug
	@echo "Installing vim-plug"
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	sudo apt install silversearcher-ag
	@echo "vim-plug bootstrapped. Running PlugInstall now for your convenience...";
	vim +PlugInstall +qa
	@echo "Done"

vim-plugin-dependencies:
	# Vim plugins some times have external dependencies.
	
	echo "Installing external plugin dependencies..."
	# This task relies on the build deps
	make build-deps
	
	# Dependency: universal-ctags
	# Used for: vim-vista
	git clone https://github.com/universal-ctags/ctags.git --depth=1
	cd ctags && ./autogen.sh && ./configure && make -j $$(nproc) && sudo make install
	
	rm -rf ctags
	# Required for the latex plugin
	sudo apt install -y latexmk
	# Required for CoC (C++)
	sudo apt install -y ccls
	echo "External for vim plugins installed"

# This task has to be .PHONY.
# Otherwise, it fails with an error that I honestly don't understand.
fat-dotfiles: vim-plugin-dependencies install-vim-plug dotfiles

dotfiles:
	mkdir -p ~/.vim
	mkdir -p ~/.config/nvim
	ln -sf ${PWD}/.vim/coc-settings.json ${HOME}/.vim/coc-settings.json
	ln -sf ${PWD}/.vimrc ${HOME}/.vimrc
	ln -sf ${PWD}/.zshrc ${HOME}/.zshrc
	ln -sf ${PWD}/.shell_aliases ${HOME}/.shell_aliases
	ln -sf ${PWD}/.p10k.zsh ${HOME}/.p10k.zsh
	ln -sf ${PWD}/.tmux.conf ${HOME}/.tmux.conf
	ln -sf ${PWD}/.condarc ${HOME}/.condarc
	ln -sf ${PWD}/.config/nvim/init.vim ${HOME}/.config/nvim/init.vim
	ln -sTf ${PWD}/VimSnippets ${HOME}/.vim/CustomSnippets
	# Make sure the submodules are initialized.
	git pull --recurse-submodules
	# Additional vim config
	ln -sf ${PWD}/.vim/asynctasks.ini ${HOME}/.vim/asynctasks.ini

update-repo:
	git pull
	git pull --recurse-submodules

config:
	rsync -av --progress config/ ~/.config/

nerdfonts:
	# Left for posterity. SHAME!
	#@echo "Installing nerdfonts. Note that this can take a _long_ time, depending on your connection."
	# The cloning is the part that takes the longest time. The repo is about 7GB big
	#git clone https://github.com/ryanoasis/nerd-fonts
	#cd nerd-fonts && ./install.sh
	#@echo "Done"
	wget https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf?raw=true -O "Sauce Code Pro Nerd Font Complete.ttf"
	# Needed for gnome terminal because reasons
	wget https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf?raw=true -O "Sauce Code Pro Nerd Font Complete Mono.ttf"
	sudo mv "Sauce Code Pro Nerd Font Complete.ttf" /usr/local/share/fonts
	sudo mv "Sauce Code Pro Nerd Font Complete Mono.ttf" /usr/local/share/fonts
	sudo fc-cache -f

cleanup:
	@echo "Cleaning up..."
	sudo apt autoremove -y

# TODO: integrate {{{
extended-documents:
	sudo apt install texlive-full

# Note; upm is not yet functional
upm:
	-git clone https://github.com/LunarWatcher/upm
	-cd upm && git pull origin master
	cd 

upm-packages:
	upm install cmake@latest
	upm install node@latest
	upm install python@latest
# }}}

dotall: update packages upm upm-packages zsh vim tmux fat-dotfiles pythoninstall goinstall nerdfonts
software: home-packages additional-packages

all: dotall software

.PHONY = all fat-dotfiles software dotall

# vim:autoindent:noexpandtab:tabstop=4:shiftwidth=4
