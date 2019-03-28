set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/.vim/plugged')

" F<N> remapping
nnoremap <F5> :NERDTreeRefreshRoot<cr>
nnoremap <F8> :TagbarToggle<cr>

"General remapping

map <C-a> <esc>ggVG"+y<CR>


" Fix backspace issues
set backspace=indent,eol,start " backspace over everything in insert mode"
" Fix that horrid arrow nav issue
set whichwrap+=<,>,h,l,[,]

" Basics

Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree'

" Utils

" Themes & colors
Plug 'NLKNguyen/papercolor-theme'
Plug 'pboettch/vim-cmake-syntax'
Plug 'flazz/vim-colorschemes'         " I can't believe this is a thing >.>
Plug 'vim-airline/vim-airline-themes'

" Language-related utils
Plug 'octol/vim-cpp-enhanced-highlight'

" Languages

Plug 'plasticboy/vim-markdown'

" Various coding-related utils
Plug 'scrooloose/nerdcommenter'
Plug 'majutsushi/tagbar'
Plug 'Yggdroot/indentLine'

"Various utils
Plug 'cohama/lexima.vim'
Plug 'alvan/vim-closetag'
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-surround'

" Autocomplete (yes, that again >.>)
Plug 'maralla/completor.vim'
Plug 'kyouryuukunn/completor-necovim'
Plug 'SirVer/ultisnips'
Plug 'w0rp/ale'                        " Well, this is linting, but still closely related

" Airline (TL;DR: contains info at the bottom of the screen)
Plug 'vim-airline/vim-airline'

" Integrations
Plug 'tpope/vim-fugitive'

" Clean up Plug

call plug#end()

" Autocomplete config

let g:completor_clang_binary = '/usr/bin/clang'
let g:completor_python_binary = '/usr/local/bin/python3'

" Anyone want some ale?
let g:ale_linters = { 'cpp': [ 'clang'  ] }

" Enable all the stuffs

filetype plugin indent on
filetype plugin on
filetype on
syntax enable

" Set all teh stuffs
set hidden 
set autoindent


"General config

set mouse=a
set t_Co=256

" Set up themes
set background=light      " Color scheme variant
colorscheme PaperColor    " Color scheme
set number                " Line numbers
set laststatus=2
set cursorline            " Active line highlighting - because it's nice 
set cursorcolumn          " The column highlighting is also incredibly nice

let g:airline_theme='tomorrow'

" Bloody tabs >.>
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent

" Fix the cursor - also makes the mode slightly more visible

let &t_SI.="\e[5 q" 
let &t_SR.="\e[4 q" 
let &t_EI.="\e[5 q" 

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

"Nerdtree config

" Auto-show NERD tree

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


nnoremap <F2> :NERDTreeToggle<CR>
let NERDTreeWinSize=32
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1

" Speaking of NERDTree...
" Let's exclude it from thet indent guides
"

" And let's fix the indent char
let g:indentLine_char = '|'

" Multi-window nav
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Remap tab to autocompletion

let g:UltiSnipsExpandTrigger="<c-n>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" nnoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" nnoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
nnoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

" Let all the thingz
let g:completor_auto_trigger = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:airline_powerline_fonts = 1
let g:indentLine_enabled = 1
let g:indentLine_setColors = 0
let g:airline#extensions#ale#enabled = 1       " Ale integration. Tavern's open y'all!

