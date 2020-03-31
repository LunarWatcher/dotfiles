
echo -e "${GREEN}Installing ryanoasis/nerd-fonts. This will take a while, depending on your internet speed.${NC}";

git clone https://github.com/ryanoasis/nerd-fonts

cd nerd-fonts && ./install.sh
echo -e "${GREEN}Done. The nerd-fonts folder has also been preserved due to its download size. If you don't need it, you can remove it manually.${NC}";
