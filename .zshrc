# Profiling
#zmodload zsh/zprof

if [[ "$(zsh --version)" =~ "zsh 5.9" ]]; then
    # Required to deal with a bug in zsh 5.9 that does something bad that I don't recall
    CASE_SENSITIVE=true
fi

uname -r | grep -q WSL
if [[ $? == 0 ]]; then
    export __LIVI_WSL__=1
    export GVIM_ENABLE_WAYLAND=1

    # Avoid printing this if running in zellij. If printing in zellij, it gets annoying very fast
    if [[ "$ZELLIJ" == "" ]]; then
        echo "                                 ⡀       "
        echo "                              ⢀⣴⣿⠟⣧      "
        echo "           ⢠⣶⢤⣀              ⣴⡿⠏⣿ ⢸⡄     "
        echo "           ⢸⠉⢿⡻⠙⠦⣄         ⢠⡞⠛⠃⢠⣷⡀⠈⣇     "
        echo "           ⢸ ⠘⣷⡄ ⠈⠙⢦⡴⣶⠖⠋⠑⠋⠉⠛⢷⣄⡀⣾⠋⣹⡷⠆     "
        echo "           ⠸⡄⢀⡿⢷⡄⢠⣾⠇          ⠙⠻⣄⣹⡇⡇     "
        echo "            ⢳⡛⣶⠄⡿⠋⠁       ⢀⡀    ⠙⢮⡿⣷     "
        echo "            ⠘⢷⢻⣺⠇    ⣶⣦   ⢻⠿⢀⣤⣤⣄  ⠙⣧     "
        echo "             ⢸⣽⡯  ⣤⣤⣤⡙⠋     ⣾⠛⣿⣿⣿⠃ ⣩⣷⣦   "
        echo "              ⣿ ⠠⣾⣿⣿⠛⢿⡄ ⣀⣀⣀ ⢿⣿⣿⣿⣟⡴⠟⢙⣪⡏   "
        echo "             ⣾⣭⣀ ⠈⢿⣿⣿⣿⣧⠞⠛⣿⢉⠙⠛⠛⣿⡍⠁  ⣠⡟    "
        echo "             ⠹⣮⡎⠙⠓⠲⠛⣿⡍   ⠙⠏   ⠉⠁ ⣀⡴⠟     "
        echo "              ⠈⠓⢶⣄  ⠈⠁⢀ ⣠⣀⣤⢶  ⣶⠒⠻⣿       "
        echo "                 ⠈⠉⣹⡟⢿⡿ ⡾ ⠷⢀⠙⢀⡛⣦ ⠸⣗      "
        echo "                  ⢰⣿⠅⣿⠼ ⠠⡧ ⠘⠂ ⠹⣾⠆ ⣸⡇     "
        echo "                  ⢸⣇⣸⣏⣰⢧⡄      ⣿⡄ ⠸⣆     "
        echo "                  ⡼⠁⣸⡏⠉⠉      ⠰⣿⠁ ⢀⡿     "
        echo "        ⣀⡤⠤⠤⠤⢤⣄⣀ ⢰⣇ ⠻⣶        ⢰⠟  ⢸⣧     "
        echo "      ⣴⠞⠛     ⣆⡏⢹⠏⣟  ⠈⠳⣶⣆   ⣦⣠⠟   ⢀⡟⣧    "
        echo "    ⢀⡞⠁ ⢰⣟⡻⠿⠷⠤⢤⣴⣏⣸⢽⣶   ⠈⠛⢦⣠⡴⠋⠁   ⢰⠿⣿⣽⣧⡀  "
        echo "   ⢠⡿    ⠉   ⣰⠞⣉ ⠉⠳⢿⣦⡄ ⢀⣠⣿⡇⣷⡀⠈  ⢀⡏   ⠈⢳⡀ "
        echo "   ⣼⠓⠄    ⢀⣤⠾⢃⣀⠠⠤   ⠙⢿⣶⣿⣿⣿⡇⣿⣿⣿⣄⣴⣾⠃⣀⣤⡉ ⠈⢳ "
        echo "   ⢻⠃    ⢠⡟⠁⣠⡀⢠⡄⠲⠆    ⢹⣿⣿⣿⡇⣿⣷⣿⣟⢍⡏ ⠳⡿⠃  ⢸⠂"
        echo "   ⠸⣆    ⠘⢧⡀ ⢠⣄⠶⠆      ⢻⣿⣿⡇⣿⣿⣿⣿⣿⣇⣀⣀  ⣠⢠⡾ "
        echo "    ⠘⢷⡀   ⣼⠋⠓ ⢠⣤       ⠈⣿⣿⡧⣿⣿⣿⣾⢷⣿⣿⣿⣷⣾⠾⠋  "
        echo "      ⠉⠓⠦⣄⣹⣼⠆⠹         ⢤⣿⣿⣧⣿⣿⣿⠏ ⠉⠛⠛⠛⠋    "
        echo "           ⠉⠉⠉⠙⠛⠛⠛⠓⠒⠒⠲⠤⢬⡏⠉⠉⠉⠉⠉           "
        echo ""
        echo "My sincerest condolences on being stuck in WSL."
    fi
fi


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Config
if [[ "$SSH_TTY" == "" ]]; then
    export EDITOR='gvim -f'
else
    export EDITOR='vim'
fi

# Copied from my RPi; no clue what the values are for
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:';

export AMETHYST_LOCATION=$HOME/programming/zsh/amethyst
if [ ! -d "$AMETHYST_LOCATION" ]; then
    export AMETHYST_LOCATION=$HOME/.config/amethyst
fi

source $AMETHYST_LOCATION/modules/everything.zsh

# Direnv {{{
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi
# }}}


# Aliases
source ~/.shell_aliases

export PATH="${DOTFILES_HOME}/scripts/bin:$PATH"

# Variables (modification + new)
export PATH="${HOME}/.local/bin:${HOME}/go/bin:$PATH"
export PATH="${HOME}/.cargo/bin:$PATH"

# if (( $+commands[clang] )); then
#     export CXX=clang++
#     export CC=clang
# else
if (( $+commands[g++-14] )); then
    export CXX=g++-14
    export CC=gcc-14
else
    export CXX=g++
    export CC=gcc
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
# WARNING: sourced from the secrets repo on the self-hosted forgejo instance.
# DO NOT USE for anything else. System-local secrets go in .zshrc.local
[ -f ~/.shell_secrets ] && . ~/.shell_secrets

if [[ $(whoami) == "pi" ]]
then
    # Unfuck SSH paths
    export PATH="/usr/local/bin:$PATH"
fi

[ -d $HOME/.deno ] && . "$HOME/.deno/env"

# The comment just above the rvm source line was auto-generated by the rvm install process.
# That said, I'm fascinated by it. Sdkman does the same thing; injecting a note stating it must
# be the last or everything will break miserably. Why do they all do this? You can't all have to
# be last or everything will break, because that would make literally all the version managers
# incompatible with each other - and I mean specifically for version managers doing different things.
# Sdkman will never conflict with rvm and vice versa, and there's no consequence to them being
# in different orders. 
#
# Why do they both still whine about being last? Fuck knows. Might be a poorly formulated way of
# trying to avoid incompatible conflicts or something that effect.
#
# Generated comment follows:
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Fun fact: steam has tools, and some of these tools even have CLI support.
# steam.zsh adds these to the path, if they're found locally.
# The script itself does not check if steam is installed, so this is done 
# separately
[ -d $HOME/.steam ] && source $DOTFILES_HOME/zsh/steam.zsh
[[ "$__LIVI_WSL__" == "1" ]] && source $DOTFILES_HOME/windows/wsl/run.zsh

[[ -s "$HOME/.local/share/pnpm" ]] && source $DOTFILES_HOME/zsh/pnpm.zsh

amethyst-plugin auto 'https://github.com/LunarWatcher/wd'
amethyst-plugin auto 'https://github.com/zsh-users/zsh-syntax-highlighting'
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
amethyst-plugin theme 'https://github.com/romkatv/powerlevel10k'
