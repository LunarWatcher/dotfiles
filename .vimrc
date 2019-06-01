" Encoding. Required for powerline fonts (at least with gVim: https://vi.stackexchange.com/q/20136/21251)
" Might be dependent on window-specific overrides. 
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

set nocompatible              " be iMproved, required
filetype off                  " required

set foldmethod=marker

call plug#begin('~/.vim/plugged')

" Navigation {{{

Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree'

"Nerdtree config

" Auto-show NERD tree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

let NERDTreeWinSize=32
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1
Plug 'terryma/vim-expand-region'

" Toggle the tree with F2 
map <F2> :NERDTreeToggle<CR>
" Remap the refresh to F5 (browser-style refreshing) 
nnoremap <F5> :NERDTreeRefreshRoot<cr>

" }}}

" Themes & colors {{{
Plug 'NLKNguyen/papercolor-theme'
Plug 'pboettch/vim-cmake-syntax'
Plug 'kien/rainbow_parentheses.vim'
Plug 'flazz/vim-colorschemes'         " I can't believe this is a thing >.>
Plug 'vim-airline/vim-airline-themes'

Plug 'RRethy/vim-illuminate'

" Disable highlighting in some files

let g:Illuminate_ftblacklist = ['nerdtree', 'md', 'json', 'markdown', 'text', 'txt']


" }}}

" Language highlighting {{{

Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'plasticboy/vim-markdown'

" }}}i

" Various coding-related utils {{{
Plug 'scrooloose/nerdcommenter'
Plug 'majutsushi/tagbar'
Plug 'alvan/vim-closetag'

Plug 'Yggdroot/indentLine'

" And let's fix the indent char
let g:indentLine_enabled = 1
let g:indentLine_setColors = 0

let g:indentLine_char = '|'
let g:indent_guides_enable_on_vim_startup = 1
autocmd FileType json :IndentLinesDisable
nnoremap <leader>it :IndentLinesToggle<cr>

" }}}

" Formatting {{{
Plug 'rhysd/vim-clang-format'

nnoremap <leader>cf :ClangFormat<cr>

" }}}

" Tunnelvision and text extensions {{{
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'itchyny/calendar.vim'

Plug 'vimwiki/vimwiki'

let g:vimwiki_list = [{'path': '~/.wiki/', 'syntax': 'markdown', 'ext': '.md'},
    \ {'path': '~/.personal/', 'syntax': 'markdown', 'ext': '.md'}]
    
" TODO: header colors
" From the docs:
"  :hi VimwikiHeader1 guifg=#FF0000
"  :hi VimwikiHeader2 guifg=#00FF00
"  :hi VimwikiHeader3 guifg=#0000FF
"  :hi VimwikiHeader4 guifg=#FF00FF
"  :hi VimwikiHeader5 guifg=#00FFFF
"  :hi VimwikiHeader6 guifg=#FFFF00

nnoremap <leader>go :Goyo 65%x95%<cr>
nnoremap <leader>ll :Limelight0.6<cr>
nnoremap <leader>c :Calendar<cr>
" }}}

" Autocomplete {{{
if has('win32')
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'powershell install.ps1',
        \ }
else
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
endif

Plug 'junegunn/fzf'
Plug 'maralla/completor.vim'

let g:completor_clang_binary = 'C:/Program Files/LLVM/bin/clang.exe'
let g:completor_python_binary = 'C:/Users/LunarWatcher/AppData/Local/Programs/Python/Python37/python.exe'
let g:completor_auto_trigger = 1

" Language server
let g:LanguageClient_serverCommands = {
  \ 'cpp': ['clangd'],
  \ 'python': ['jedi'],
  \ }

let g:completor_refresh_always = 0 " avoid flickering
let g:completor_python_omni_trigger = ".*"
set formatexpr=LanguageClient_textDocument_rangeFormatting()
set omnifunc=LanguageClient#complete

" LanguageClient mapping 

function SetLSPShortcuts()
  nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
  nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
  nnoremap <silent> <F3> :call LanguageClient#textDocument_rename()<CR>       
  nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
  nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
  nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
  nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
  nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
endfunction()

augroup LSP
  autocmd!
  autocmd FileType cpp,c,python call SetLSPShortcuts()
  
augroup END

" Re-map CTRL+space to auto-complete. IDEA-inspired
inoremap <C-Space> <C-x><C-o>


" }}}

" Airline (TL;DR: contains info at the bottom of the screen) {{{
Plug 'vim-airline/vim-airline'

let g:airline_theme='papercolor'
let g:airline_powerline_fonts = 1

" Integrations 
Plug 'tpope/vim-fugitive'
" }}}

" Project config {{{
Plug 'embear/vim-localvimrc'

let g:localvimrc_ask = 0
let g:localvimrc_sandbox = 0

" }}}

" General every-day use {{{
Plug 'scy/vim-mkdir-on-write'
Plug 'tpope/vim-surround'
" }}}

" Discord integration {{{
Plug 'ananagame/vimsence'
" }}}

call plug#end() 

" Basic enabling {{{ 


filetype plugin indent on
filetype plugin on
filetype on
syntax enable
" }}}

" Basic settings {{{
set hidden 
set autoindent
set showcmd               " Helps managing leader timeout 

"General config

set mouse=a
set t_Co=256

set exrc                  " Local vimrc

" Fix backspace issues
set backspace=indent,eol,start " backspace over everything in insert mode"
" Fix that horrid arrow nav issue
set whichwrap+=<,>,h,l,[,]

" }}}

" Themes and visual configurations {{{
set background=light      " Color scheme variant
colorscheme PaperColor    " Color scheme
set number                " Line numbers
set laststatus=2
set cursorline            " Active line highlighting - because it's nice 
set clipboard=unnamed

set guifont=Source\ Code\ Pro\ for\ Powerline:h11:cANSI " Source Code Pro <3
set guifontwide=Source\ Code\ Pro\ for\ Powerline:h11:cANSI " gvim
" }}}

" Anti-tab squad {{{
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
" }}}

" Cursor config {{{

let &t_SI.="\e[5 q" 
let &t_SR.="\e[4 q" 
let &t_EI.="\e[5 q"
" }}}

" Paths for Vim-generated files {{{
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
" }}}

" Super-cd {{{
" Super cd - changes the current working directory, as well as changing the NERDTree root
function! Scd(location)
    execute 'cd '.a:location
    execute 'NERDTree '.a:location
endfunction

command! -nargs=1 Scd call Scd(<f-args>)

" }}}

" Plug mapping {{{
nnoremap <leader>pi <esc>:PlugInstall<cr>
nnoremap <leader>pc <esc>:PlugClean<cr>
nnoremap <leader>pu :PlugUpdate<cr>
nnoremap <F8> :TagbarToggle<cr>
" }}}

" Multi-window nav {{{
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" }}}

" Leader re-mapping {{{

" Adapted from https://github.com/towc/dotfiles/blob/master/.vimrc#L462-L475
let g:autoSave = 0
function! ToggleAutoSave()
    if g:autoSave == 0
        let g:autoSave = 1
        augroup AutoSaveAu
            au TextChanged,TextChangedI <buffer> silent write
        augroup END
    else 
        let g:autoSave = 0
        au! AutoSaveAu
    endif
endfunction
nnoremap <leader>as :call ToggleAutoSave()<cr>



" }}}
