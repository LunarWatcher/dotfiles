emacs:
	ln -sf ${PWD}/.emacs ${HOME}/.emacs

zellij:
	mkdir -p ~/.config/zellij
	ln -sf ${PWD}/config/zellij/config.kdl ${HOME}/.config/zellij/config.kdl

rofi:
	mkdir -p ${HOME}/.config/rofi
	mkdir -p ${HOME}/.config/rofi/themes

	ln -sf ${PWD}/config/rofi/config.rasi ${HOME}/.config/rofi/config.rasi
	ln -sf ${PWD}/config/rofi/themes/catppuccin-latte.rasi ${HOME}/.config/rofi/themes/catppuccin-latte.rasi


common-dotfiles: emacs rofi zellij

DOTFILE_TARGETS += common-dotfiles
