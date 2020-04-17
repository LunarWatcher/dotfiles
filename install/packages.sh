
echo -e "${GREEN}Installing packages...${NC}"
sudo apt-add-repository universe
sudo apt update

sudo apt install -y thefuck curl python3-pip python-pkg-resources cmake build-essential libssl-dev autoconf automake 
# lolcat is borked from apt. Use gem instead. 
sudo apt remove -y lolcat 
sudo gem install lolcat 

# These are used along with Vim
sudo apt install -y  silversearcher-ag clang-format 
# ag: used for some fzf stuff
# clang-format: formats code 

# Apparently required for thefuck
python3 -m pip install traitlets

if [[ $zsh == 1 ]]; then
    echo -e "${GREEN}Installing zsh, oh-my-zsh, and powerlevel10k...${NC}"
    sudo apt install -y zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
    # Sourcing is a required step to load the $ZSH_CUSTOM. This is a system bootstrapper, so the current shell is most likely bash
    zsh -c 'source ~/.zshrc; git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k'
fi;


echo -e "${GREEN}Done.${NC}";
