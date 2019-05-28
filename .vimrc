set nocompatible              " be iMproved, required
filetype off                  " required

# Encoding. Required for powerline fonts (at least with gVim: https://vi.stackexchange.com/q/20136/21251)
# Might be dependent on window-specific overrides. 
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

call plug#begin('~/.vim/plugged')

" Refresh the root like a browser uwu
nnoremap <F5> :NERDTreeRefreshRoot<cr>

" Various update utils
nnoremap <leader>pi <esc>:w<cr>:source ~/.vimrc<cr>:PlugInstall<cr>
nnoremap <leader>pc <esc>:w<cr>:source ~/.vimrc<cr>:PlugClean<cr>
nnoremap <leader>pu :PluginUpdate<cr>
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
Plug 'kien/rainbow_parentheses.vim'
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
Plug 'jiangmiao/auto-pairs'
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
Plug 'vim-syntastic/syntastic'

" Integrations
Plug 'tpope/vim-fugitive'

" Project config
Plug 'LucHermitte/lh-vim-lib'
Plug 'LucHermitte/local_vimrc'

" Discord integration
Plug 'ananagame/vimsence'

" Clean up Plug

call plug#end()


" Rainbow parentheses

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParethesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Autocomplete config

let g:completor_clang_binary = '<insert path to clang here>'
let g:completor_python_binary = '<insert path to python here>'

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
set clipboard+=unnamedplus

set guifont=Source\ Code\ Pro\ for\ Powerline:h11:cANSI " Source Code Pro <3
set guifontwide=Source\ Code\ Pro\ for\ Powerline:h11:cANSI " gvim

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
"Nerdtree config

" Auto-show NERD tree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


map <F2> :NERDTreeToggle<CR>
let NERDTreeWinSize=32
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeAutoDeleteBuffer=1

" Speaking of NERDTree...
" Let's exclude it from thet indent guides

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

let g:UltiSnipsExpandTrigger="<c-<space>>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

nnoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
nnoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
nnoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

" Let all the thingz
let g:completor_auto_trigger = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:airline_powerline_fonts = 1
let g:indentLine_enabled = 1
let g:indentLine_setColors = 0
let g:airline#extensions#ale#enabled = 1       " Integrate the airline with Ale.
let g:local_vimrc = ['.vim', 'project.vim']

" Functions

" Super cd - runs both cd and changes the NERDTree root
function! Scd(location)
    execute 'cd '.a:location
    execute 'NERDTree '.a:location
endfunction


command! -nargs=1 Scd call Scd(<f-args>)

