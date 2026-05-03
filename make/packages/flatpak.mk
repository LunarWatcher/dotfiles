flatpak-packages:
	flatpak install -y flathub org.gnome.clocks
	flatpak install -y flathub org.flameshot.Flameshot

flatpak-packages-home:
# World of Warcraft needs wine-staging-tkg to boot. Not sure why, but it's apparently
# a recurring bug.
# It's trivial to install through ProtonPlus, and it seems to work fine even though
# it's in a sandbox
	flatpak install flathub com.vysp3r.ProtonPlus
# Better than lutris, and doesn't have outright malicious mantainers arguably actively trying to deceive people about
# their AI slop machine use: https://github.com/lutris/lutris/discussions/6530#discussion-9617375
	flatpak install flathub com.usebottles.bottles

	flatpak install com.spotify.Client

flatpak-packages-work:
	-flatpak install flathub io.dbeaver.DBeaverCommunity

NON_SERVER_TARGETS += flatpak-packages
HOME_TARGETS += flatpak-packages-home
WORK_TARGETS += flatpak-packages-work
