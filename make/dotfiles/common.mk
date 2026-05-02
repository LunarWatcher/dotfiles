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

config:
	rsync -av --progress config/ ~/.config/

common-dotfiles: config emacs rofi zellij
	ln -sf ${PWD}/.zshrc ${HOME}/.zshrc
	ln -sf ${PWD}/.shell_aliases ${HOME}/.shell_aliases
	ln -sf ${PWD}/.p10k.zsh ${HOME}/.p10k.zsh

DOTFILE_TARGETS += common-dotfiles
