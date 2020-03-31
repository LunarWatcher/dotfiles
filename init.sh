#!/bin/bash

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
    echo "  --autodeps   - Whether or not to automatically install necessary dependencies. These can be left out, of course."
    exit;
fi;

has "--packages"
packages=$?
has "--zsh"
zsh=$?
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
has "--autodeps"
autodeps=$?

# Verbose all teh commandz 
set -v

### Install standard packages ###
if [[ $packages == 1 ]]; then
    ./install/packages.sh
fi;


### Build and install Vim ###
if [[ $vim == 1 ]]; then
    ./install/buildvim.sh

fi;

### Install polybar ###
if [[ $polybar == 1 ]]; then
    ./install/buildpolybar.sh
fi;

### Copy dotfiles ###
if [[ $dotfiles == 1 ]]; then
    ./install/dotfiles.sh
fi;

### Bootstrap vim-plug ###
if [[ $vimplug == 1 ]]; then
    ./install/vimplug.sh
fi;

### Install nerd-fonts ###
if [[ $nerdfonts == 1 ]]; then
    ./install/nerdfonts.sh
fi;

echo -e "${PINK}Bootstrapper run. Enjoy your system!${NC}";
set +v

