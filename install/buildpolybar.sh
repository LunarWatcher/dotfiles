echo -e "${GREEN}Building polybar...${NC}"
sudo apt install -y cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev libxcb-composite0-dev xcb libxcb-ewmh2
git clone --recursive https://github.com/polybar/polybar
cd polybar 

mkdir build && cd build
cmake ..
make -j 8
sudo make install 

cd ../..
rm -rf polybar

echo -e "${GREEN}Done.${NC}"
