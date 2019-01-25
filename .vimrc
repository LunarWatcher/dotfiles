set nocompatible              " be iMproved, required
filetype off                  " required


set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Tmux utils (thanks towc)

nnoremap <leader>pi <esc>:w<cr>:source ~/.vimrc<cr>:PluginInstall<cr>
nnoremap <leader>pc <esc>:w<cr>:source ~/.vimrc<cr>:PluginClean<cr>
nnoremap <leader>pu :PluginUpdate<cr>

" General remapping

map <C-a> <esc>ggVG"+y<CR>

" Basics

Plugin 'VundleVim/Vundle.vim'
Plugin 'christoomey/vim-tmux-navigator'

" Utils

Plugin 'scrooloose/nerdtree'
Plugin 'nathanaelkane/vim-indent-guides'

" Auto-show NERD tree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


" Themes & colors
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'pboettch/vim-cmake-syntax'

" Clean up Vundle

call vundle#end()
filetype plugin indent on

set t_Co=256

" Set up themes
set background=light
colorscheme PaperColor
set number
set laststatus=2

" Bloody tabs >.>
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab


" Nerdtree config + multi-window management

map <F2> :NERDTreeToggle<CR>
let NERDTreeWinSize=32
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeAutoDeleteBuffer=1

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
