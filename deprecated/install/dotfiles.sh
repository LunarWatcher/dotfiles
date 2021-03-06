# Raw dotfile installer. This does NOT have any prompts

echo $autokey

echo -e "${GREEN}Copying Linux dotfiles...${NC}";
echo "vimrc...";
cp .vimrc ~/
# Let's avoid pushing packages
if [[ $autodeps == 1 ]]; then 

    echo "Installing external plugin dependencies..."
    # Required for running. The build will otherwise fail. These are installed alongside packages, but these are enforced here
    # to make sure they aren't excluded 
    sudo apt install -y automake autotools-dev autoconf libjansson-dev  

    git clone https://github.com/universal-ctags/ctags.git --depth=1
    cd ctags
    ./autogen.sh
    ./configure
    make
    sudo make install
    echo "Dependencies installed"
    cd ..
fi;

if [[ $zsh == 0 ]]; then
    echo "bashrc...";
    cp .bashrc ~/
else
    echo "zshrc and zsh config..."

    cp .zshrc ~/
    cp .p10k.zsh ~/
fi;

echo "Aliases..."
cp .shell_aliases ~/

echo "taskrc..."
cp .taskrc ~/

if [[ $autokey == 1 ]]; then
    sudo apt install -y autokey-gtk
    rsync -av --progress config/ ~/.config/
else
    rsync -av --progress config/ ~/.config/ --exclude "autokey" 
fi;
echo -e "${GREEN}Done. Enjoy your install!${NC} 💜";
