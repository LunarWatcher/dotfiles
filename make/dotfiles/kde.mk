konsole:
	mkdir -p $$HOME/.local
	mkdir -p $$HOME/.local/share
	mkdir -p $$HOME/.local/share/konsole
# Konsole does not handle soft links
	ln -f "kde/konsole/Profile 1.profile" "$$HOME/.local/share/konsole/Profile 1.profile"
	ln -f "kde/konsole/Gnome terminal.colorscheme" "$$HOME/.local/share/konsole/Gnome terminal.colorscheme"

kde: konsole

DOTFILE_TARGETS += kde
