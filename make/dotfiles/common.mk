emacs:
	ln -sf ${PWD}/.emacs ${HOME}/.emacs

	mkdir ${HOME}/.emacs-saves

zsh-deps:
	-git clone https://codeberg.org/LunarWatcher/amethyst ~/.config/amethyst

config:
	# TODO: find replacement for rsync: https://github.com/RsyncProject/rsync/issues/929
	# rsync -av --progress config/ ~/.config/

	mkdir -p ~/.config
	mkdir -p ~/.config/rofi
	mkdir -p ~/.config/rofi/themes
	mkdir -p ~/.config/zellij

	cp config/kcalcrc ~/.config

	ln -sf ${PWD}/config/rofi/config.rasi ${HOME}/.config/rofi/config.rasi
	ln -sf ${PWD}/config/rofi/themes/catppuccin-latte.rasi ${HOME}/.config/rofi/themes/catppuccin-latte.rasi

	ln -sf ${PWD}/config/zellij/config.kdl ${HOME}/.config/zellij/config.kdl

common-dotfiles: config emacs zsh-deps
	ln -sf ${PWD}/.zshrc ${HOME}/.zshrc
	ln -sf ${PWD}/.shell_aliases ${HOME}/.shell_aliases
	ln -sf ${PWD}/.p10k.zsh ${HOME}/.p10k.zsh

DOTFILE_TARGETS += common-dotfiles
