sdkman:
	curl -s "https://get.sdkman.io?rcupdate=false" | bash

jetbrains-toolbox: sdkman
	wget -O jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
	tar -xf jetbrains-toolbox.tar.gz
	# The extracted folder is jetbrains-toolbox-<version label>, hence the glob
	# This moves it to a stable location
	sudo mv jetbrains-toolbox-* /opt/jetbrains-toolbox/

	rm jetbrains-toolbox.tar.gz
	# Jetbrains toolbox does not provide a .desktop
	sudo cp shims/jetbrains-toolbox.desktop /usr/share/applications/jetbrains-toolbox.desktop
