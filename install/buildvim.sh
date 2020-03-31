
echo -e "${GREEN}Installing vim build deps...${NC}";
sudo apt install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev
git clone https://github.com/vim/vim.git
cd vim
cd src
echo -e "${GREEN}Done. Building vim...${NC}";
# gVim
./configure --enable-gui=gtk2 --with-features=huge --enable-multibyte \
    --enable-rubyinterp=yes --enable-python3interp=yes \
    --enable-perlinterp=yes --enable-luainterp=yes \ 
    --enable-gui=gtk2 --enable-cscipe --prefix=/usr/local 
make -j 8
sudo make install

cd ../../
rm -rf vim

echo -e "${GREEN}Vim installed.${NC}"
