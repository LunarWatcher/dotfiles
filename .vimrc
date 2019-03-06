
set nocompatible              " be iMproved, required
filetype off                  " required


set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Refresh the root like a browser uwu
nnoremap <F5> :NERDTreeRefreshRoot<cr>

" Various update utils

nnoremap <leader>pi <esc>:w<cr>:source ~/.vimrc<cr>:PluginInstall<cr>
nnoremap <leader>pc <esc>:w<cr>:source ~/.vimrc<cr>:PluginClean<cr>
nnoremap <leader>pu :PluginUpdate<cr>

" General remapping

map <C-a> <esc>ggVG"+y<CR>
" Fix backspace issues
set backspace=indent,eol,start " backspace over everything in insert mode"
" Fix that horrid arrow nav issue
set whichwrap+=<,>,h,l,[,]

" Basics

Plugin 'VundleVim/Vundle.vim'
Plugin 'christoomey/vim-tmux-navigator'

" Utils

Plugin 'scrooloose/nerdtree'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Shougo/neocomplete.vim'

" Auto-show NERD tree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


" Themes & colors
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'pboettch/vim-cmake-syntax'

" Various utils
Plugin 'jiangmiao/auto-pairs'
Plugin 'alvan/vim-closetag'

" Clean up Vundle

call vundle#end()

" Enable all the stuffs

filetype plugin indent on
filetype plugin on
filetype on
syntax on
" Enable the autocomplete
let g:neocomplete#enable_at_startup = 1

" General config

set mouse=a
set t_Co=256

" Set up themes
set background=light      " Color scheme variant
colorscheme PaperColor    " Color scheme
set number                " Line numbers
set laststatus=2

" Bloody tabs >.>
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent

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

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//


