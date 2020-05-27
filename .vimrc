" Encoding. Required for powerline fonts (at least with gVim: https://vi.stackexchange.com/q/20136/21251)
" Might be dependent on window-specific overrides.
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set nocompatible              " be iMproved, required
filetype off                  " required

" Folding {{{
set foldmethod=marker
" set nofoldenable

nnoremap <leader>ft :set foldenable!
nnoremap <leader>fe :set foldenable
nnoremap <leader>fd :set nofoldenable

augroup folding
    autocmd FileType vim setlocal foldenable
    autocmd FileType markdown,vimwiki setlocal nofoldenable
augroup END
augroup config
    autocmd FileType markdown,vimwiki,text setlocal wrap
    autocmd FileType markdown,vimwiki setlocal conceallevel=0
    autocmd FileType markdown let g:indentLine_enabled=0
augroup END
" }}}

"let g:fzf_colors =
"\ { 'fg':      ['fg', 'Normal'],
  "\ 'bg':      ['bg', 'Normal'],
  "\ 'hl':      ['fg', 'Comment'],
  "\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  "\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  "\ 'hl+':     ['fg', 'Statement'],
  "\ 'info':    ['fg', 'PreProc']/
  "\ 'border':  ['fg', 'Ignore'],
  "\ 'prompt':  ['fg', 'Conditional'],
  "\ 'pointer': ['fg', 'Exception'],
  "\ 'marker':  ['fg', 'Keyword'],
  "\ 'spinner': ['fg', 'Label'],
  "\ 'header':  ['fg', 'Comment'] }

let g:python3_host_prog = 'python3'
let g:python_host_prog = 'python2'
call plug#begin('~/.vim/plugged')

"Plug 'vim/killersheep'
" Navigation {{{

Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree'
Plug 'anschnapp/move-less'
Plug 'yuttie/comfortable-motion.vim'

Plug 'zefei/vim-wintabs'
Plug 'zefei/vim-wintabs-powerline' " Powerline rendering


" Fuzzy finder
if has('win32')
    " Windows note: Some Assembly Required:tm:
    " Install FZF manually. This can be done with either
    " `go get -u github.com/junegunn/fzf`, or by installing
    " one of the pre-built binaries manually.
    Plug 'junegunn/fzf'
else
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
endif
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' } }

command! -bang -nargs=? -complete=dir HFiles call fzf#run(fzf#vim#with_preview({
        \ 'source': 'ag --hidden --ignore .git -g ""',
        \ 'sink': 'e',
        \ 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' }
        \ }))

command! -bang -nargs=? -complete=dir HNGFiles call fzf#run(fzf#vim#with_preview({
        \ 'source': 'ag --hidden --skip-vcs-ignores --ignore .git -g ""',
        \ 'sink': 'e',
        \ 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' }
        \ }))

nnoremap <leader>zx :HFiles<cr>
nnoremap <leader>zX :HNGFiles<cr>

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

" Comfortable motion config
" Enable mousewheel
noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>
" Consistency with Vim
let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"
" }}}

" Themes & colors {{{
Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/seoul256.vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'rakr/vim-one'
Plug 'rakr/vim-two-firewatch'

Plug 'pboettch/vim-cmake-syntax'
Plug 'luochen1990/rainbow'
" Rainbows {{{
augroup RainbowLangs
    autocmd!
    " Enables rainbow parentheses for some specific filetypes
    autocmd FileType cpp,java,javascript RainbowToggleOn
augroup end
" Disables the rainbow parentheses globally
let g:rainbow_active = 0
" }}}
" Old {{{
" Archived for future use
" Plug 'flazz/vim-colorschemes'         " I can't believe this is a thing >.>
" }}}
Plug 'vim-airline/vim-airline-themes'

Plug 'RRethy/vim-illuminate'
Plug 'markonm/traces.vim'

" Disable highlighting in some files

let g:Illuminate_ftblacklist = ['nerdtree', 'md', 'json', 'markdown', 'text', 'txt']

" }}}

" Language highlighting {{{
Plug 'sheerun/vim-polyglot'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'

set concealcursor=nc
set conceallevel=0

" }}}

" Various coding-related utils {{{
Plug 'scrooloose/nerdcommenter'
"Plug 'majutsushi/tagbar'
Plug 'liuchengxu/vista.vim'
Plug 'alvan/vim-closetag'
Plug 'wsdjeg/vim-todo/'

Plug 'tpope/vim-surround'
" Plug 'seletskiy/vim-autosurround'

Plug 'Yggdroot/indentLine'

" Codi isn't supported by Windows. TODO: Revisit this later
if !has("win32") && (!has("nvim") && has('job') && has('channel') || has('nvim'))
    Plug 'metakirby5/codi.vim'
endif

" And let's fix the indent char
let g:indentLine_enabled = 1
let g:indentLine_setColors = 1

let g:indentLine_char = '|'
let g:indent_guides_enable_on_vim_startup = 1
autocmd FileType json,startify,calendar :IndentLinesDisable
nnoremap <leader>it :IndentLinesToggle<cr>

let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }


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
let g:vimwiki_list = [{'path': '~/.wiki/', 'syntax': 'default', 'ext': '.mdvw'},
            \ {'path': '~/.personal/', 'syntax': 'default', 'ext': '.mdvw'}]


nnoremap <leader>go :Goyo 65%x95%<cr>
nnoremap <leader>ll :Limelight!! 0.6<cr>
nnoremap <leader>c :Calendar<cr>

let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1

" }}}

" Language server/autocomplete/utils {{{

Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py --clangd-completer' }
Plug 'machakann/vim-Verdin'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

let g:UltiSnipsExpandTrigger="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<C-l>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

" }}}

" Airline (TL;DR: contains info at the bottom of the screen) {{{
Plug 'vim-airline/vim-airline'

let g:airline_theme='onehalflight'
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
" Plug 'codeape2/vim-multiple-monitors'
Plug 'LunarWatcher/vim-multiple-monitors'

Plug 'jceb/vim-orgmode'

Plug 'tpope/vim-speeddating'
Plug 'scy/vim-mkdir-on-write'
" Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs' " Automatic

Plug 'haya14busa/incsearch.vim'

Plug 'mbbill/undotree'
nnoremap <F9> :UndotreeToggle<cr>
" Auto-disables highlighting
let g:incsearch#auto_nohlsearch=1

" Search remapping
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Highlight remapping
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" Disable BS for pair deletion
let g:AutoPairsMapBS = 0

" }}}

" Discord integration {{{
Plug 'hugolgst/vimsence'
" Dev variant
"Plug '/mnt/LinuxData/programming/vim/vimsence'
let g:vimsence_ignored_directories = [ '~/', 'C:/Users/LunarWatcher', "/home/lunarwatcher" ]
let g:vimsence_ignored_file_types = [ 'vimwiki' ]
let g:vimsence_discord_flatpak = 1
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
        \ {'c': '~/.vimrc'},
        \ ]
" }}}

" Font and font-related plugins {{{

"set guifont=Source\ Code\ Pro\ for\ Powerline:h11:cANSI " Source Code Pro <3
"set guifontwide=Source\ Code\ Pro\ for\ Powerline:h11:cANSI " gvim
" Sauce Code Pro is Source Code Pro, but with added symbols (compared to the
" powerline variant as well)
"
try
    if has("win32")
        " The Nerd Fonts are broken on windows.
        " https://github.com/ryanoasis/nerd-fonts/issues/269
        " Up since 2018, no patch in sight.
        " set guifont=SauceCodePro\ Nerd\ Font:h11
        set guifont=Source\ Code\ Pro\ for\ Powerline:h11:cANSI
    elseif has("unix")
        set guifont=SauceCodePro\ Nerd\ Font\ 11
        Plug 'ryanoasis/vim-devicons'
    endif
catch
    echo "Failed to find SauceCodePro - falling back to SourceCodePro, and disabling devicons"
    if has("win32")
        set guifont=Source\ Code\ Pro\ for\ Powerline:h11:cANSI
    elseif has("unix")
        set guifont=Source\ Code\ Pro\ for\ Powerline\ 11
    endif
endtry
" }}}

let g:AutoPairsShortcutFastWrap = "<C-f>"
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

" YCM {{{
let g:Verdin#cooperativemode=1
let g:Verdin#autocomplete=0

let g:ycm_semantic_triggers = {
    \ 'vim': ['#', ':']
    \ }

" Disable re-asking
let g:ycm_confirm_extra_conf=0
let g:ycm_clangd_args=['-cross-file-rename']

augroup YcmAUConfig
    autocmd!
    autocmd FileType c,cpp let b:ycm_hover = {
        \ 'command': 'GetDoc',
        \ 'syntax': &filetype
        \ }
augroup END


" }}}

" }}}

" Config {{{

" Basic enabling {{{

set nowrap                " Soft wrapping is annoying
set smartcase             " Search enhancements
filetype plugin indent on
filetype plugin on
"filetype on
syntax enable

set incsearch             " Along withsearch highlighting, it shows search results while typing
set hlsearch              " Search highlighting
set splitright

set wildmenu              " GUI popup for command autocomplete options
" }}}

" Configure indents {{{

set cindent
set cino=N-s
set cino+=g0
" }}}

" Filetypes {{{

autocmd BufRead,BufNewfile conanfile.txt set filetype=dosini
autocmd BufRead,BufNewFile SConstruct set filetype=python
autocmd Bufread,BufNewFile SConscript set filetype=python
" }}}

" Basic settings {{{
set hidden
set autoindent
set showcmd               " Helps managing leader timeout

"General config

set mouse=a
if has("termguicolors")
    set termguicolors         " Required for true color terminals. If statement for compat
else
    set t_Co=256
endif

set exrc                  " Local vimrc

" Fix backspace issues
set backspace=indent,eol,start " backspace over everything in insert mode"
" Fix that horrid arrow nav issue
set whichwrap+=<,>,h,l,[,]

" }}}

" Themes and visual configurations {{{
set background=light      " Color scheme variant

let g:PaperColor_Theme_Options = {
            \ 'language': {
            \     'cpp': { 'highlight_standard_library': 1 }
            \ },
            \ 'theme': { 'default': { 'transparent_background': 1 } }
  \ }

" Colorschemes + alternate variants
" =================================
colorscheme PaperColor    " Color scheme
"colorscheme one
" colorscheme onedark
" colorscheme onehalfdark
" colorscheme onehalflight
"colorscheme seoul256-light
" colorscheme two-firewatch

" =================================

" Mods {{{
" Paper {{{
" hi Function guifg='#005faf' ctermfg='25'

"}}}

" General light, not paper {{{

"let g:terminal_ansi_colors = ['#eeeeee', '#af0000', '#008700', '#5f8700',
            "\ '#0087af', '#878787', '#005f87',
            "\ '#444444', '#bcbcbc', '#d70000', '#d70087', '#8700af',
            "\ '#d75f00', '#d75f00', '#005faf', '#005f87']

" }}}

"}}}

set number                " Line numbers
set laststatus=2
set cursorline            " Active line highlighting - because it's nice
" clipboard=unnamed == evil. Yanking internally in vim (or i.e. deleting text)
" causes the system clipboard to be overridden. CTRL+Ins/Shift+Ins in Vim/gVim
" still enables system clipboard interaction without "+p
" Additionally, deleting text using the delete key in visual mode can override
" the system clipboard if this option is set
" set clipboard=unnamed

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
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p")
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p")
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p")
endif
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
nnoremap <F8> :Vista!!<cr>
" }}}

" General mapping {{{
inoremap <leader>fi <esc>:YcmCompleter FixIt<cr>i
inoremap <leader>w <esc>:w<cr>i

nnoremap <leader>x viw

" }}}

" Multi-window nav {{{
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" }}}

" Leader remapping {{{

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

" Clears search highlighting without disabling it in general
nnoremap <leader>chl :noh<cr>
nnoremap <leader>ts :%s/ \+$//g<cr>
" Remaps <leader>q to closing a single tab. Using :q closes the entire buffer,
" including all other tabs nested within it. :WintabsClose closes one. All the
" buffers live on if :q is used instead of <leader>q, but they're not nested
" in the same way.
nnoremap <leader>q :WintabsClose<cr>

" Todo tracking
nnoremap <leader>t :Ag \(FIXME\)\\|\(TODO\)<cr>

" }}}

" Other remapping {{{

" This needs to be remapped on keyboards without a bracket button (i.e. on
" scandinavian or german keyboards)
autocmd FileType help nnoremap <C-t> <C-]>

" Comfortable motion remapping {{{
nmap <PageUp> :call comfortable_motion#flick(-100)<cr>
nmap <PageDown> :call comfortable_motion#flick(100)<cr>
" }}}

" Wintabs remapping {{{
nnoremap <M-1> :WintabsGo 1<cr>
nnoremap <M-2> :WintabsGo 2<cr>
nnoremap <M-3> :WintabsGo 3<cr>
nnoremap <M-4> :WintabsGo 4<cr>
nnoremap <M-5> :WintabsGo 5<cr>
nnoremap <M-6> :WintabsGo 6<cr>
nnoremap <M-7> :WintabsGo 7<cr>
nnoremap <M-8> :WintabsGo 8<cr>
nnoremap <M-9> :WintabsGo 9<cr>
nnoremap <M-0> :WintabsLast<cr>
nnoremap <C-PageUp> :WintabsPrevious<cr>
nnoremap <C-PageDown> :WintabsNext<cr>
" }}}

" {{{ gVim
" has("gvim") isn't a thing - use has("gui_running") to check if gVim is
" running.
if has("gui_running")
    set wak=no
    " Disable the GUI toolbars (they're noisy)
    " Note to self: there cannot be a space between the = and letter.
    " Otherwise, it thinks i.e. " m" is the option, not just "m".
    set guioptions -=m
    set guioptions -=T
    set guioptions +=k
    if has("win32")
        " Set the language to English
        language messages English_United States
        set langmenu=en_US.UTF-8
    endif
    autocmd GUIEnter * set vb t_vb=

    " This mapping only works in Vim. The alleged workarounds on the wiki do
    " not work
    imap <C-BS> <C-w>
endif
" }}}

" External config {{{

" This enables system-specific configurations that don't make sense to keep in
" .vimrc (i.e. sensitive config), or config that is system-specific (i.e.
" startify bookmarks).
if !isdirectory($HOME."/.vim-extern/")
    " Create the directory
    call mkdir($HOME."/.vim-extern")

else
    if filereadable($HOME."/.vim-extern/.systemrc")
        source $HOME/.vim-extern/.systemrc
    endif
endif



" }}}

