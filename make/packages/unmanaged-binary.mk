init-livi-unmanaged:
	mkdir -p ${HOME}/.local
	mkdir -p ${HOME}/.local/livi-unmanaged

unmanaged-firefox-nightly: init-livi-unmanaged
	cd /tmp && curl -L 'https://download.mozilla.org/?product=firefox-nightly-latest-l10n-ssl&os=linux64&lang=en-GB' -o firefox.tar.xz \
		&& tar -xf firefox.tar.xz -C "${HOME}/.local/livi-unmanaged"

	cp shims/unmanaged-firefox-nightly.desktop "${HOME}/.local/share/applications/unmanaged-firefox-nightly.desktop"

SOFTWARE_TARGETS += unmanaged-firefox-nightly
