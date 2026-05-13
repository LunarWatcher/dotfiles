upm:
	-sudo bash -c "$$(wget -O- https://raw.githubusercontent.com/LunarWatcher/upm/master/tools/install.sh)"

umbra:
	-bash -c "$$(wget -O- https://raw.githubusercontent.com/LunarWatcher/umbra/master/scripts/install.sh)"

NON_SERVER_TARGETS += umbra upm
