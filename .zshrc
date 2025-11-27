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

# Path to your oh-my-zsh installation.
export ZSH="/${HOME}/.oh-my-zsh"

# Theming
ZSH_THEME="powerlevel10k/powerlevel10k"

# Use a sensible date format
# yyyy-mm-dd is also fine, but mm.dd.yyyy is disgusting and needs to disappear
HIST_STAMPS="dd.mm.yyyy"

# Plugins
plugins=(
    wd
    vim-interaction
    direnv
)

# Prevent wd from converting paths (https://github.com/ohmyzsh/ohmyzsh/issues/8996#issuecomment-640512998)
export WD_SKIP_EXPORT=1

# 8c5a606 and b52dd1a were made by a slop agent, but were non-functional, so letting it slide for now. This block prevents omz from loading
# if more slop commits appear. This is incompatible with omz update, so a pull has to be done as well. This is not optimal, but it's the
# only reasonably stable way to detect AI slop before it fucks the shell (or worse)
local LAST_SLOP_THRESHOLD=2
echo $(cd $ZSH && git pull) > /dev/null || true
matches=$(cd $ZSH && git log --format="%an" | grep -i copilot)
if (( $(echo $matches | wc -l) > $LAST_SLOP_THRESHOLD)); then
    bash -c "cd $ZSH && git log --format='%Cgreen%h%Creset %<(25)%an (%<(50)%ae) %ad%x09%s' | grep -i Copilot"
    echo "⚠️  AI slop in omz exceeded last known threshold of $LAST_SLOP_THRESHOLD. Crosscheck and report"
    echo "omz will not be loaded to avoid an AI slop supply chain attack"
else
    source $ZSH/oh-my-zsh.sh
fi

# Config
if [[ "$SSH_TTY" == "" ]]; then
    export EDITOR='gvim -f'
else
    export EDITOR='vim'
fi

# Options {{{
unsetopt autocd
# }}}

# TODO: why on earth does this do -f && with extra steps?
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
[[ -s "$HOME/.nvm" ]] && source $DOTFILES_HOME/zsh/nvm.zsh
