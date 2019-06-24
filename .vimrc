" Encoding. Required for powerline fonts (at least with gVim: https://vi.stackexchange.com/q/20136/21251)
" Might be dependent on window-specific overrides. 
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

set nocompatible              " be iMproved, required
filetype off                  " required

language messages English_United States
set langmenu=en_US.UTF-8  

set foldmethod=marker
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
call plug#begin('~/.vim/plugged')

" Navigation {{{

Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree'
Plug 'anschnapp/move-less'
Plug 'yuttie/comfortable-motion.vim'

" Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
command! -bang -nargs=? -complete=dir HFiles
  \ call fzf#vim#files(<q-args>, {'source': 'ag --hidden --ignore .git -g ""'}, <bang>0)
nnoremap <leader>zx :HFiles<cr>
command! -bang -nargs=? -complete=dir HNGFiles
  \ call fzf#vim#files(<q-args>, {'source': 'ag --hidden --skip-vcs-ignores --ignore .git -g ""'}, <bang>0)
nnoremap <leader>zX :HNGFiles<cr>

"Nerdtree config

let NERDTreeWinSize=32
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
Plug 'terryma/vim-expand-region'

" Toggle the tree with F2 
map <F2> :NERDTreeToggle<CR>
" Remap the refresh to F5 (browser-style refreshing) 
nnoremap <F5> :NERDTreeRefreshRoot<cr>

" }}}

" Themes & colors {{{

Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/seoul256.vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'rakr/vim-one'

Plug 'pboettch/vim-cmake-syntax'
Plug 'junegunn/rainbow_parentheses.vim'
"" Rainbows {{{
augroup RainbowLangs
    autocmd!
    autocmd FileType cpp,java,javascript RainbowParentheses
augroup end
let g:rainbow#pairs = [ ['(', ')'], ['[', ']'], ['{','}'], ['<','>'] ]
" }}}
" Old {{{
" Archived for future use 
" Plug 'flazz/vim-colorschemes'         " I can't believe this is a thing >.>
" }}}
Plug 'vim-airline/vim-airline-themes'

Plug 'RRethy/vim-illuminate'

" Disable highlighting in some files

let g:Illuminate_ftblacklist = ['nerdtree', 'md', 'json', 'markdown', 'text', 'txt']

" }}}

" Language highlighting {{{

Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'

set concealcursor=nc
set conceallevel=2

" }}}

" Various coding-related utils {{{
Plug 'scrooloose/nerdcommenter'
Plug 'majutsushi/tagbar'
Plug 'alvan/vim-closetag'
Plug 'seletskiy/vim-autosurround'

Plug 'Yggdroot/indentLine'

" And let's fix the indent char
let g:indentLine_enabled = 1
let g:indentLine_setColors = 1

let g:indentLine_char = '|'
let g:indent_guides_enable_on_vim_startup = 1 
autocmd FileType json,startify,calendar :IndentLinesDisable
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

let g:vimwiki_conceallevel = 0

" Augmented in an attempt to avoid Vim registering regular .md files as
" vimwiki files
let g:vimwiki_list = [{'path': '~/.wiki/', 'syntax': 'markdown', 'ext': '.mdvw'},
            \ {'path': '~/.personal/', 'syntax': 'markdown', 'ext': '.mdvw'}]


nnoremap <leader>go :Goyo 65%x95%<cr>
nnoremap <leader>ll :Limelight!! 0.6<cr>
nnoremap <leader>c :Calendar<cr>

let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1

augroup calendar-mappings
    autocmd!
    " unmap <C-n>, <C-p> for other plugins
    autocmd FileType calendar nunmap <buffer> <C-n>
    autocmd FileType calendar nunmap <buffer> <C-p>

    " Re-map <C-N> to creating a new calendar
    autocmd FileType calendar nmap <buffer> <C-M>n <Plug>(calendar_add)
augroup END
" }}}

" Autocomplete {{{

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

let g:deoplete#enable_at_startup = 1
let g:python3_host_prog = 'python'


" Extensions {{{
Plug 'Shougo/neco-vim'

" }}}

" Language server {{{

if has('win32')
    Plug 'autozimu/LanguageClient-neovim', {
                \ 'branch': 'next',
                \ 'do': 'powershell ./install.ps1'
                \ }
else
    Plug 'autozimu/LanguageClient-neovim', {
                \ 'branch': 'next',
                \ 'do': 'bash install.sh'
                \ }
endif

let g:LanguageClient_serverCommands = {
            \ 'cpp': ['clangd'],
            \ 'python': ['jedi']
            \ }

" }}}

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

Plug 'mbbill/undotree'
nnoremap <leader>ut :UndotreeToggle<cr>

" }}}

" Discord integration {{{
Plug 'ananagame/vimsence'
" Dev variant 
" Plug 'D:/programming/vimsence'
let g:vimsence_ignored_directories = [ '~/', 'C:\Users\LunarWatcher' ]
let g:vimsence_ignored_file_types = [ 'vimwiki' ]
" }}}

" Start screen {{{
Plug 'mhinz/vim-startify'

let g:startify_lists = [
        \ { 'type': 'files', 'header': ['    MRU'] },
        \ { 'type': 'dir', 'header': ['    MRU ' . getcwd()] },
        \ { 'type': 'sessions', 'header': ['    Sessions'] },
        \ { 'type': 'bookmarks', 'header': ['    Bookmarks'] },
        \ { 'type': 'commands', 'header': ['    Commands'] },
        \ ]

let g:startify_files_number = 10

let g:startify_bookmarks = [
        \ '~/.vimrc',
        \ ]
" }}}

call plug#end() 

" Delayed config {{{

" Start screen config {{{
function! s:center(lines) abort
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
            \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction

let g:startify_custom_header = s:center(startify#fortune#boxed())

" }}}
" Language server config {{{

" Integration

call deoplete#custom#source('LanguageClient', 'min_pattern_length', 2)


" LanguageClient mapping 

function SetLSPShortcuts()
    " Shortcuts
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
imap <expr> <C-space> deoplete#mappings#manual_complete()

" }}}

" }}}

" Config {{{ 

" Basic enabling {{{ 

set nowrap                " Soft wrapping is annoying
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
" Colorschemes + alternate variants
" =================================
" colorscheme PaperColor    " Color scheme
" colorscheme one
" colorscheme onedark
" colorscheme onehalfdark
" colorscheme onehalflight
colorscheme seoul256-light
" =================================
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

" }}}

" Super-cd {{{
" Super cd - changes the current working directory, as well as changing the NERDTree root
function! Scd(location)
    execute 'cd '.a:location
    execute 'NERDTree '.a:location
endfunction

command! -nargs=1 -complete=dir Scd call Scd(<f-args>)

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

if empty($MYVIMRC)
  let $MYVIMRC = "~/.vimrc"
endif
nnoremap <leader>ve :split $MYVIMRC<cr>
nnoremap <leader>vE :e $MYVIMRC<cr>
nnoremap <leader>rel :source $MYVIMRC<cr>

" }}}
"
