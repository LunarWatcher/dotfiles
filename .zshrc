# Add deno completions to search path
#if [[ ":$FPATH:" != *":/home/olivia/.zsh/completions:"* ]]; then export FPATH="/home/olivia/.zsh/completions:$FPATH"; fi
# Profiling
#zmodload zsh/zprof

if [[ "$(zsh --version)" =~ "zsh 5.9" ]]; then
    CASE_SENSITIVE=true
fi

uname -r | grep -q WSL
if [[ $? == 0 ]]; then
    export __LIVI_WSL__=1
    export GVIM_ENABLE_WAYLAND=1

    setxkbmap no nodeadkeys > /dev/null 2>&1
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

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
    echo "Friendly reminder fox says:"
    echo "   Run unfuck-wsl-keyboard.bat before you continue"
fi


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="/${HOME}/.oh-my-zsh"

# Theming
ZSH_THEME="powerlevel10k/powerlevel10k"

# Use a sensible date format
# yyyy.mm.dd is also fine, but mm.dd.yyyy is disgusting and needs to disappear
HIST_STAMPS="dd.mm.yyyy"

# Plugins
plugins=(
    wd
    vim-interaction
)

# Prevent wd from converting paths (https://github.com/ohmyzsh/ohmyzsh/issues/8996#issuecomment-640512998)
export WD_SKIP_EXPORT=1

source $ZSH/oh-my-zsh.sh

# Config
if [[ "$SSH_TTY" == "" ]]; then
    export EDITOR='gvim -f'
else
    export EDITOR='vim'
fi

# Options {{{
unsetopt autocd
# }}}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
source ~/.shell_aliases

export PATH="${DOTFILES_HOME}/scripts/bin:$PATH"

# Variables (modification + new)
export PATH="${HOME}/.local/bin:${HOME}/go/bin:$PATH"
export PATH="${HOME}/.cargo/bin:$PATH"

if (( $+commands[clang] )); then
    export CXX=clang++
    export CC=clang
else
    export CXX=g++
    export CC=gcc
fi
# Fix with some OpenSSL-based apps
# TODO: This is a shit variable, and doesn't match my new conventions
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

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

# TODO: integrate this or fully axe whatever  the fuck pyenv is
# It was lurking in the makefile, but I have no idea what it's for
#export PYENV_ROOT="$HOME/.pyenv"
#[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
if [[ -d /${HOME}/.deno ]]; then
    . "/${HOME}/.deno/env"
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

if [[ "$(hostname)" == "vixen" ]]; then
    export PATH="/media/data-ssd-1/SteamLibrary/steamapps/common/Aseprite:$PATH"
fi
