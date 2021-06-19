update:
	sudo apt update && sudo apt upgrade -y

build-deps:
	@echo "Installing general build dependencies..."
	sudo apt install -y autoconf automake autotools-dev build-essential \
		libjansson-dev libtool libtool-bin cmake
	@echo "Done."

vim-build-deps: # Grabs Vim build dependencies
	@echo "Installing dependencies for the Vim build..."
	# This contains potentially redundant packages
	sudo apt install -y libncurses5-dev \
		libgtk2.0-dev libatk1.0-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev \
		python3.8-dev ruby-dev lua5.3 liblua5.3-dev luajit libluajit-5.1-dev libperl-dev
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
	sudo apt install -y npm nodejs
	
	# Install general stuff
	sudo apt install -y git thefuck curl python-pkg-resources libssl-dev \
		wget nano xclip tmux cargo
	
	# TODO: clang 12
	# C++ dev stuff
	sudo apt install -y clang-10 clang-format-10
	# Install build dependencies
	make build-deps
	
	@echo "Done".

theming:
	sudo add-apt-repository ppa:papirus/papirus
	sudo apt update && sudo apt install papirus-icon-theme

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

	# Installs Steam
	wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb && sudo apt install -y ./steam.deb
	
additional-packages:
	# installs peek (gif screen recorder)
	flatpak install flathub com.uploadedlobster.peek

	flatpak install flathub com.bitwarden.desktop

	# Installs ksnip for its editing capabilities
	wget https://github.com/ksnip/ksnip/releases/download/v1.7.1/ksnip-1.7.1.deb && sudo apt install -y ./ksnip-1.7.1.deb

pythoninstall:
	-[ ! -d "$${HOME}/.pyenv" ] && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

goinstall:
	sudo apt install -y golang
	go get -u github.com/boyter/scc/

zsh: # Installs zsh and oh-my-zsh
	# Install the shell
	sudo apt install -y zsh
	
	curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
	make powerlevel
	# Install zsh syntax highlighting
	zsh -c 'source ~/.zshrc; git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'

powerlevel:
	zsh -c 'source ~/.zshrc; git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $${ZSH_CUSTOM}/themes/powerlevel10k'

vim:
	@echo "Building Vim..."
	make vim-build-deps
	-git clone https://github.com/vim/vim.git
	cd vim/src && \
		./configure --enable-gui=gtk2 --with-features=huge --enable-multibyte \
			--enable-rubyinterp=yes --enable-python3interp=yes \
			--enable-perlinterp=yes --enable-luainterp=yes --with-luajit=yes \
			--enable-gui=gtk2 --enable-cscope --prefix=/usr/local \
			--with-python3-config-dir=$$(python3.8-config --configdir) --with-python3-command=python3.8 \
			--enable-largefile --enable-fail-if-missing && \
		make -j 8 && \
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
	cd ctags && ./autogen.sh && ./configure && make -j 4 && sudo make install
	
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
	ln -s -f ${PWD}/.vim/coc-settings.json /home/${USER}/.vim/coc-settings.json
	ln -s -f ${PWD}/.vimrc /home/${USER}/.vimrc
	ln -s -f ${PWD}/.zshrc /home/${USER}/.zshrc
	ln -s -f ${PWD}/.shell_aliases /home/${USER}/.shell_aliases
	ln -s -f ${PWD}/.p10k.zsh /home/${USER}/.p10k.zsh
	ln -s -f ${PWD}/.tmux.conf /home/${USER}/.tmux.conf
	ln -s -f ${PWD}/.config/nvim/init.vim /home/${USER}/.config/nvim/init.vim
	ln -sTf ${PWD}/VimSnippets /home/${USER}/.vim/CustomSnippets
	# Make sure the submodules are initialized.
	git pull --recurse-submodules
	ln -s -f ${PWD}/gdb-dashboard/.gdbinit /home/${USER}/.gdbinit
	# Additional vim config
	ln -s -f ${PWD}/.vim/asynctasks.ini /home/${USER}/.vim/asynctasks.ini

update-repo:
	git pull
	git pull --recurse-submodules

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

uncrustify:
	-git clone https://github.com/uncrustify/uncrustify
	-cd uncrustify && git pull origin master
	cd uncrustify && mkdir -p build && cd build && cmake .. \
				&& make -j 8 && sudo make install

all: update packages zsh vim tmux fat-dotfiles pythoninstall goinstall

.PHONY = all fat-dotfiles
# vim:autoindent:noexpandtab:tabstop=4:shiftwidth=4
