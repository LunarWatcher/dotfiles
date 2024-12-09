flatpak-packages:
	flatpak install -y flathub org.gnome.clocks
	flatpak install -y flathub org.flameshot.Flameshot
	flatpak install -y org.gnome.Calendar
	# Replacement: org.gnome.Todo
	# Requires Endeavour to be updated with caldav support
	flatpak install -y io.github.mrvladus.List

NON_SERVER_TARGETS += flatpak-packages
