emacs:
	ln -sf ${PWD}/.emacs ${HOME}/.emacs

zellij:
	mkdir -p ~/.config/zellij
	ln -sf ${PWD}/config/zellij/config.kdl ${HOME}/.config/zellij/config.kdl

common-dotfiles: emacs zellij

DOTFILE_TARGETS += common-dotfiles
