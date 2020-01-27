NC='[0m'
GREEN='[1;32m'
RED='[1;31m'
PINK='[1;95m'
echo -e "${PINK}Welcome to Olivia's system initializer."
echo "This bash script initializes a system with my standards and dotfiles."
echo "The purpose of this script is simply to let me not have to bother with manual installs of stuff whenever I start a new system."
echo "The end of this script also copies the dotfiles over, so if you'd just like a dotfile install, this script also does that."
echo "Reading the script first is highly encouraged, because there's not a lot of prompts. Check what stuff does before you agree to it."
echo -e "${NC}"

echo -e "${RED}All questions are y/n${NC}"
read -p "${GREEN}Install packages? (Assumes apt is present)${NC} " -n 1;
echo "";

if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo apt install -y thefuck curl python3-pip python-pkg-resources
fi;

read -p "${GREEN}Build Vim? (Assumes apt, git, and a properly linked compiler are present)${NC} " -n 1;
echo "";

if [[ $REPLY =~ ^[Yy]$ ]]; then 
    echo -e "${GREEM}Installing vim build deps...${NC}"

        libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
        libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
        python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev
    git clone https://github.com/vim/vim.git
    cd vim
    cd src

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
fi;

echo -e "${RED}WARNING:${NC} Proceeding with the dotfiles copy will overwrite your local dotfiles, if present. Copy any dotfiles you'd like to keep before running this. Skipping is also an option if this isn't what you signed up for. "
read -p "Continue? " -n 1;
echo "";

if [[ $REPLY =~ ^[Yy]$ ]]; then 
    echo -e "${GREEN}Copying Linux dotfiles...${NC}";
    echo "vimrc...";
    cp .vimrc ~/
    echo "bashrc...";
    cp .bashrc ~/

    echo -e "${GREEN}Done. Enjoy your install!${NC} 💜";
fi;

read -p "${GREEN}Bootstrap vim-plug?${NC} " -n 1;
echo "";

if [[ $REPLY =~ ^[Yy]$ ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "vim-plug bootstrapped.";
    vim +PlugInstall
fi;

read -p "${GREEN}Install ryanoasis/nerd-fonts? Note: Installs _all_ fonts. Note that the download is slow due to the huge amount of data required. Don't run this if you're low on data, or don't want to wait around. This is the last step of the bootstrapping process; there's nothing else after this. (27.01.20: 5.38GB)${NC}" -n 1;
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then 
    git clone https://github.com/ryanoasis/nerd-fonts

    cd nerd-fonts && ./install.sh

fi;

echo -e "${PINK}Bootstrapper run. Enjoy your system!${NC}";
