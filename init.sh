NC='[0m'
GREEN='[1;32m'
RED='[1;31m'
PINK='[1;95m'

POSITIONAL=()

while [[ $# -gt 0 ]]
do
    key="$1"

    POSITIONAL+=("$1") 
    shift # past argument
done

function has() {

    case "${POSITIONAL[@]}" in *"$1"*)
        return 1;
    esac;
}

echo -e "${PINK}Welcome to Olivia's system initializer."
echo "This bash script initializes a system with my standards and dotfiles."
echo "The purpose of this script is simply to let me not have to bother with manual installs of stuff whenever I start a new system."
echo "The end of this script also copies the dotfiles over, so if you'd just like a dotfile install, this script also does that."
echo "Reading the script first is highly encouraged, because there's not a lot of prompts asking about specific packages. Check what stuff does before you agree to it."
echo -e "${NC}"

has "--help"
hr=$?

if [[ ${#POSITIONAL[@]} == 0 ]]; then
    
    hr=1;
fi;

if [[ $hr == 1 ]];
then
    echo "Usage: ./init.sh flags"
    echo "At least one flag is required to take any action. 0 flags prints this message. Several flags can be used together. "
    echo "  --packages   - installs standard packages"
    echo "  --zsh        - prefer zsh over bash. This copies .zshrc if --dotfiles is set, and installs zsh and oh-my-zsh if --packages is defined."
    echo "  --vim        - Builds Vim from source"
    echo "  --polybar    - Builds polybar from source"
    echo "  --dotfiles   - Installs dotfiles"
    echo "  --autokey    - Installs autokey + config (Note: config set up for a Scandinavian keyboard)"
    echo "  --vim-plug   - Bootstraps vim-plug and runs PlugInstall afterwards. This option assumes you have Vim already."
    echo "  --nerdfonts  - Installs nerdfonts. WARNING: This has a download size of 5.37 GB (27.01.20) and will take a while to complete, but is also run last, so it doesn't block the other actions."
    exit;
fi;

has "--packages"
packages=$?
has "--vim"
vim=$?
has "--polybar"
polybar=$?
has "--dotfiles"
dotfiles=$?
has "--autokey"
autokey=$?
has "--vim-plug"
vimplug=$?
has "--nerdfonts"
nerdfonts=$?


### Install standard packages ###
if [[ $packages == 1 ]]; then
    echo -e "${GREEN}Installing packages...${NC}"
    sudo apt-add-repository universe
    sudo apt update

    sudo apt install -y thefuck curl python3-pip python-pkg-resources cmake build-essential libssl-dev 
    # lolcat is borked from apt. Use gem instead. 
    sudo apt remove -y lolcat 
    sudo gem install -y lolcat 

    if [[ $zsh == 1 ]]; then
        echo -e "${GREEN}Installing zsh and oh-my-zsh...${NC}"
        sudo apt install zsh
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        echo -e "${GREEN}Done.${NC}";
    fi;


    echo -e "${GREEN}Done.${NC}";
fi;


### Build and install Vim ###
if [[ $vim == 1 ]]; then 
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
fi;

### Install polybar ###
if [[ $polybar == 1 ]]; then
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
fi;

### Copy dotfiles ###
if [[ $dotfiles == 1 ]]; then 
    echo -e "${GREEN}Copying Linux dotfiles...${NC}";
    echo "vimrc...";
    cp .vimrc ~/
    
    if [[ $zsh == 0 ]]; then
        echo "bashrc...";
        cp .bashrc ~/
    else
        echo "zshrc and dependencies..."
        zsh -c "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k"
        cp .zshrc ~/
    fi;  

    if [[ $autokey == 1 ]]; then
        sudo apt install -y autokey-gtk
        rsync -av --progress config ~/.config/
    else
        rsync -av --progress config/ ~/.config/ --exclude "autokey" 
    fi;
    echo -e "${GREEN}Done. Enjoy your install!${NC} 💜";
fi;

### Bootstrap vim-plug ###
if [[ $vimplug == 1 ]]; then
    echo -e "${GREEN}Installing vim-plug...${NC}";
    
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "vim-plug bootstrapped. Running PlugInstall now for your convenience...";
    vim +PlugInstall

    echo -e "${GREEN}Done.${NC}";

fi;

### Install nerd-fonts ###
if [[ $nerdfonts == 1 ]]; then
    echo -e "${GREEN}Installing ryanoasis/nerd-fonts. This will take a while, depending on your internet speed.${NC}";

    git clone https://github.com/ryanoasis/nerd-fonts

    cd nerd-fonts && ./install.sh
    echo -e "${GREEN}Done. The nerd-fonts folder has also been preserved due to its download size. If you don't need it, you can remove it manually.${NC}";
fi;

echo -e "${PINK}Bootstrapper run. Enjoy your system!${NC}";
