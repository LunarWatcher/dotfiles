# Installs vim-plug, and installs plugins 
echo -e "${GREEN}Installing vim-plug...${NC}";

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "vim-plug bootstrapped. Running PlugInstall now for your convenience...";
vim +PlugInstall

echo -e "${GREEN}Done.${NC}";
