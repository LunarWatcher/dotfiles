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
)

source $ZSH/oh-my-zsh.sh

# Config 
export LANG=en_US.UTF-8
export EDITOR='vim'

eval $(thefuck --alias)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
