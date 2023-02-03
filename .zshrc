# Profiling
#zmodload zsh/zprof

if [[ "$(zsh --version)" =~ "zsh 5.9" ]]; then
    CASE_SENSITIVE=true
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="/home/${USER}/.oh-my-zsh"

# Theming
ZSH_THEME="powerlevel10k/powerlevel10k"

# Use a sensible date format
HIST_STAMPS="dd.mm.yyyy"

# Plugins
plugins=(
    git
    wd
    vim-interaction
)

# Prevent wd from converting paths (https://github.com/ohmyzsh/ohmyzsh/issues/8996#issuecomment-640512998)
export WD_SKIP_EXPORT=1

source $ZSH/oh-my-zsh.sh

# Config
export LANG=en_US.UTF-8
if [[ "$SSH_TTY" == "" ]]; then
    export EDITOR='gvim -f'
else
    export EDITOR='vim'
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases

if [ -f ~/.zsh.sysrc ]
then
    # .zshrc but sensitive
    source ~/.zsh.sysrc
fi
source ~/.shell_aliases

# Variables (modification + new)
export PATH="/home/${USER}/.local/bin:/home/${USER}/go/bin:$PATH"
export PATH="/home/lunarwatcher/.cargo/bin:$PATH"
# export PATH="/home/lunarwatcher/anaconda3/bin:$PATH"  # commented out by conda initialize

if (( $+commands[clang] )); then
    export CXX=clang++
    export CC=clang
else
    export CXX=g++
    export CC=gcc
fi
# Fix with some OpenSSL-based apps
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

# upm <3
export PATH="/opt/upm/active/bin:$PATH"

if [[ $(whoami) == "pi" ]]
then
    # Unfuck SSH paths
    export PATH="/usr/local/bin:$PATH"
fi
