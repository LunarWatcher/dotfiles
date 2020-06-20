update:
	sudo apt update && sudo apt upgrade -y

build-deps:
	@echo "Installing general build dependencies..."
	sudo apt install -y autoconf automake autotools-dev build-essential \
		libjansson-dev libtool libtool-bin
	@echo "Done."

vim-build-deps: # Grabs Vim build dependencies
	@echo "Installing dependencies for the Vim build..."
	# This contains potentially redundant packages
	sudo apt install -y libncurses5-dev \
		libgtk2.0-dev libatk1.0-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
		python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev
	@echo "Done"

packages: # Install base packages
	@echo "Installing packages..."
	sudo apt update && sudo apt install -y software-properties-common
	-sudo apt-add-repository universe && sudo apt update
	# Fix lolcat (the apt version is broken)
	sudo apt remove -y lolcat
	sudo apt install -y ruby
	sudo gem install lolcat
	
	# Install general stuff
	sudo apt install -y git thefuck curl python3-pip python-pkg-resources libssl-dev \
		wget nano xclip
	
	# C++ dev stuff
	sudo apt install -y clang-9
	# Install build dependencies
	make build-deps
	
	@echo "Done".

tmux:
	mkdir -p ~/.tmux
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

home-packages:
	# Installs home packages.
	# These are definitely _not_ barebone packages, and extend beyond basic use.
	# The version of LibreOffice that ships with Mint is _ancient_. The FlatHub variant
	# is officially endorsed, it's a _lot_ newer, a lot faster, and a lot prettier
	sudo apt purge libreoffice && sudo apt autoremove
	flatpak install flathub org.libreoffice.LibreOffice
	
	# Flatpak Discord doesn't fuck up and block libc++
	flatpak install flathub com.discordapp.Discord

	# Installs Steam
	wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb && sudo apt install -y ./steam.deb
	
	# Installs bitwarden (password manager)
	snap install bitwarden
	
	# installs peek (gif screen recorder)
	flatpak install flathub com.uploadedlobster.peek

pythoninstall:
	sudo python3 -m pip install --upgrade pip
	# Required for thefuck
	python3 -m pip install --user traitlets
	# Used by my own C++ projects
	python3 -m pip install --user virtualenv

goinstall:
	sudo apt install -y golang
	go get -u github.com/boyter/scc/

zsh: # Installs zsh and oh-my-zsh
	# Install the shell
	sudo apt install -y zsh
	
	curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
	make powerlevel

powerlevel:
	zsh -c 'source ~/.zshrc; git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $${ZSH_CUSTOM}/themes/powerlevel10k'

vim:
	@echo "Building Vim..."
	make vim-build-deps
	git clone https://github.com/vim/vim.git
	cd vim/src && \
		./configure --enable-gui=gtk2 --with-features=huge --enable-multibyte \
			--enable-rubyinterp=yes --enable-python3interp=yes \
			--enable-perlinterp=yes --enable-luainterp=yes \
			--enable-gui=gtk2 --enable-cscope --prefix=/usr/local && \
		make -j 8 && \
		sudo make install
	rm -rf vim
	@echo "Done"

install-vim-plug: # Installs junegunn/vim-plug
	@echo "Installing vim-plug"
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
	cd ctags && ./autogen.sh && ./configure && make -j 4 && sudo make install
	
	rm -rf ctags
	# Required for the latex plugin
	sudo apt install -y latexmk
	echo "External for vim plugins installed"

# This task has to be .PHONY.
# Otherwise, it fails with an error that I honestly don't understand.
fat-dotfiles: vim-plugin-dependencies install-vim-plug dotfiles

dotfiles:
	ln -s -f ${PWD}/.vimrc /home/${USER}/.vimrc
	ln -s -f ${PWD}/.zshrc /home/${USER}/.zshrc
	ln -s -f ${PWD}/.shell_aliases /home/${USER}/.shell_aliases
	ln -s -f ${PWD}/.p10k.zsh /home/${USER}/.p10k.zsh
	ln -s -f ${PWD}/.tmux.conf /home/${USER}/.tmux.conf

config:
	rsync -av --progress config/ ~/.config/

nerdfonts:
	@echo "Installing nerdfonts. Note that this can take a _long_ time, depending on your connection."
	# The cloning is the part that takes the longest time. The repo is about 7GB big
	git clone https://github.com/ryanoasis/nerd-fonts
	cd nerd-fonts && ./install.sh
	@echo "Done"

cleanup:
	@echo "Cleaning up..."
	sudo apt autoremove -y

all: update packages zsh vim tmux fat-dotfiles pythoninstall goinstall

.PHONY = all fat-dotfiles
# vim:autoindent:noexpandtab:tabstop=4:shiftwidth=4
