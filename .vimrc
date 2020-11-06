" Base configuration {{{
" Encoding. Required for powerline fonts (at least with gVim: https://vi.stackexchange.com/q/20136/21251)
" Might be dependent on window-specific overrides.
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set nocompatible              " be iMproved, required
filetype off                  " required

let g:python3_host_prog = 'python3'
" }}}
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
augroup END
set linebreak

" }}}
" Plugins {{{
call plug#begin('~/.vim/plugged')

" Navigation {{{
Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree'
Plug 'anschnapp/move-less'
Plug 'yuttie/comfortable-motion.vim'

Plug 'zefei/vim-wintabs'
Plug 'zefei/vim-wintabs-powerline' " Powerline rendering
" }}}

" Fuzzy finder {{{
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
Plug 'terryma/vim-expand-region'
" }}}

" Themes & colors {{{
Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/seoul256.vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'rakr/vim-one'
Plug 'rakr/vim-two-firewatch'

Plug 'pboettch/vim-cmake-syntax'
Plug 'luochen1990/rainbow'

Plug 'RRethy/vim-illuminate'
Plug 'markonm/traces.vim'
" }}}

" Language highlighting {{{
Plug 'sheerun/vim-polyglot'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'
Plug 'lervag/vimtex'
" }}}

" Various coding-related utils {{{
Plug 'scrooloose/nerdcommenter'
Plug 'liuchengxu/vista.vim'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'

Plug 'Yggdroot/indentLine'

" Codi isn't supported by Windows.
if !has("win32") && (!has("nvim") && has('job') && has('channel') || has('nvim'))
    Plug 'metakirby5/codi.vim'
endif

" }}}

" Text extensions {{{
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'vimwiki/vimwiki'
" }}}

" Coding utilities {{{
Plug 'rhysd/vim-clang-format'

Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py --clangd-completer' }
Plug 'machakann/vim-Verdin'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"Plug '/mnt/LinuxData/programming/vim/tmux-multiterm.vim'
Plug 'LunarWatcher/tmux-multiterm.vim'
" }}}

" Airline {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" }}}

" Git integration {{{
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
" }}}

" Project config {{{
Plug 'embear/vim-localvimrc'
" }}}

" General every-day use {{{
Plug 'LunarWatcher/vim-multiple-monitors'
Plug 'tpope/vim-speeddating'
Plug 'scy/vim-mkdir-on-write'
"Plug 'Krasjet/auto.pairs'
Plug 'tmsvg/pear-tree'
Plug 'haya14busa/incsearch.vim'
Plug 'mbbill/undotree'
" }}}

" Discord integration {{{
"Plug 'hugolgst/vimsence'
"Plug '/mnt/LinuxData/programming/vim/vimsence'
" }}}

" Start screen {{{
Plug 'mhinz/vim-startify'
" }}}

" Font-related stuff {{{
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

call plug#end()
" }}}
" Plugin config {{{
" Plug mapping {{{
nnoremap <leader>pi <esc>:PlugInstall<cr>
nnoremap <leader>pc <esc>:PlugClean<cr>
nnoremap <leader>pu :PlugUpdate<cr>
nnoremap <F8> :Vista!!<cr>
" }}}
" Start screen config {{{
function! s:center(lines) abort
let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
return centered_lines
endfunction

let g:startify_custom_header = s:center(startify#fortune#boxed())

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
nnoremap <leader>fix <esc>:YcmCompleter FixIt<cr>
" }}}
" Autopairs {{{

"let g:AutoPairsShortcutFastWrap = "<C-f>"
" Disable BS for pair deletion
"let g:AutoPairsMapBS = 0
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_repeatable_expand = 0
" }}}
" Vimsence {{{
let g:vimsence_ignored_directories = [ '~/', 'C:/Users/LunarWatcher', "/home/lunarwatcher" ]
let g:vimsence_ignored_file_types = [ 'vimwiki' ]
let g:vimsence_discord_flatpak = 1
" }}}
" Undotree {{{
nnoremap <F9> :UndotreeToggle<cr>
" }}}
" Incsearch {{{

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

" }}}
" Local vimrc {{{
let g:localvimrc_ask = 0
let g:localvimrc_sandbox = 0

set exrc
" }}}
" Airline {{{
let g:airline_theme = 'papercolor'
let g:airline_powerline_fonts = 1
" }}}
" Ultisnips {{{
let g:UltiSnipsExpandTrigger="<C-e>"
let g:UltiSnipsJumpForwardTrigger="<C-b>"
let g:UltiSnipsJumpBackwardTrigger="<C-z>"
" }}}
" Vimwiki {{{
let g:vimwiki_conceallevel = 0
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1

" Augmented in an attempt to avoid Vim registering regular .md files as
" vimwiki files
let g:vimwiki_list = [{'path': '~/.wiki/', 'syntax': 'default', 'ext': '.mdvw'},
            \ {'path': '~/.personal/', 'syntax': 'default', 'ext': '.mdvw'}]
let g:vimwiki_ext2syntax = {'.mdvw': 'media'}
" }}}
" Junegunn plugins {{{

nnoremap <leader>go :Goyo 65%x95%<cr>
nnoremap <leader>ll :Limelight!! 0.6<cr>
" }}}
" Vim clang-format {{{

nnoremap <leader>cf :ClangFormat<cr>
" }}}
" Vista {{{ "
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
" }}} Vista "
" IndentLine {{{ "
" And let's fix the indent char
let g:indentLine_enabled = 1
let g:indentLine_setColors = 1

let g:indentLine_char = '|'
let g:indent_guides_enable_on_vim_startup = 1
autocmd FileType json,startify,calendar :IndentLinesDisable
nnoremap <leader>it :IndentLinesToggle<cr>
" }}} IndentLine "
" Vim illuminate {{{ "
" Disable highlighting in some files
let g:Illuminate_ftblacklist = ['nerdtree', 'md', 'json', 'markdown', 'text', 'txt']
" }}} Vim illuminate "
" Rainbows {{{
augroup RainbowLangs
    autocmd!
    " Enables rainbow parentheses for some specific filetypes
    autocmd FileType cpp,java,javascript :RainbowToggleOn
augroup end
" Disables the rainbow parentheses globally
let g:rainbow_active = 0
" }}}
" FZF {{{ "
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
" }}} FZF "
" NERDTree {{{ "
let NERDTreeWinSize=32
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" Toggle the tree with F2
map <F2> :NERDTreeToggle<CR>
" Remap the refresh to F5 (browser-style refreshing)
nnoremap <F5> :NERDTreeRefreshRoot<cr>
" }}} NERDTree "
" Comfortable motion {{{ "
" Enable mousewheel in normal mode
noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>

nmap <PageUp> :call comfortable_motion#flick(-100)<cr>
nmap <PageDown> :call comfortable_motion#flick(100)<cr>

" Consistency with Vim
let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"

" }}} Comfortable motion "
" Wintabs {{{
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

" Remaps <leader>q to closing a single tab. Using :q closes the entire buffer,
" including all other tabs nested within it. :WintabsClose closes one. All the
" buffers live on if :q is used instead of <leader>q, but they're not nested
" in the same way.
nnoremap <leader>q :WintabsClose<cr>
" }}}
" Plasticboy markdown {{{
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
" }}}
" Indentline {{{
" Fix retarded issue with auto-conceal to 2
let g:indentLine_setConceal = 0
" }}}
" Vimtex {{{
let g:tex_flavor = "latex"
" }}}
" Codi {{{
let g:codi#interpreters = {
    \ 'python': {
        \ 'bin': 'python3',
        \ 'prompt': '^\(>>>\|\.\.\.\) ',
    \ },
\ }
" }}}
" }}}
" Config {{{
" Basic enabling {{{
set nowrap                " Soft wrapping is annoying
set smartcase             " Search enhancements
filetype plugin indent on
filetype plugin on
syntax enable

set linespace=2           " BREATHE!

set incsearch             " Along withsearch highlighting, it shows search results while typing
set hlsearch              " Search highlighting
set splitright

set wildmenu              " GUI popup for command autocomplete options

set number                " Line numbers
set laststatus=2
set cursorline            " Active line highlighting - because it's nice

set hidden
set autoindent
set showcmd               " Helps managing leader timeout

" Deals with annoying editing conceal
set concealcursor=
set conceallevel=0

" Enable the mouse
set mouse=a

" Look at all the pretty colors
if has("termguicolors")
    set termguicolors         " Required for true color terminals. If statement for compat
else
    set t_Co=256
endif

" Fix backspace issues
set backspace=indent,eol,start " backspace over everything in insert mode"
" Fix that horrid arrow nav issue
set whichwrap+=<,>,h,l,[,]
" }}}
" Configure indents {{{
set cindent
set cino=N-s
set cino+=g0
" }}}
" Add non-standard filetypes {{{
autocmd BufRead,BufNewfile conanfile.txt set filetype=dosini
autocmd BufRead,BufNewFile SConstruct set filetype=python
autocmd Bufread,BufNewFile SConscript set filetype=python
" }}}
" Themes and visual configurations {{{
set background=light      " Color scheme variant

let g:PaperColor_Theme_Options = {
            \ 'language': {
            \     'cpp': { 'highlight_standard_library': 1 }
            \ }
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

" General light, not paper {{{

"let g:terminal_ansi_colors = ['#eeeeee', '#af0000', '#008700', '#5f8700',
            "\ '#0087af', '#878787', '#005f87',
            "\ '#444444', '#bcbcbc', '#d70000', '#d70087', '#8700af',
            "\ '#d75f00', '#d75f00', '#005faf', '#005f87']

" }}}

"}}}
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
" }}}
" Mappings {{{
" Multi-window nav {{{
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
" }}}
" Autosave {{{
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
" Vimrc {{{
if empty($MYVIMRC)
  let $MYVIMRC = "~/.vimrc"
endif
nnoremap <leader>ve :split $MYVIMRC<cr>
nnoremap <leader>vE :e $MYVIMRC<cr>
nnoremap <leader>rel :source $MYVIMRC<cr>
" }}}
" Uncategorized mapping {{{

" Clears search highlighting without disabling it in general
nnoremap <leader>chl :noh<cr>

" Clears trailing spaces from the current file
nnoremap <leader>ts :%s/ \+$//g<cr>

" This needs to be remapped on keyboards without a bracket button (i.e. on
" scandinavian or german keyboards)
autocmd FileType help nnoremap <C-t> <C-]>

" Trick for remapping escape to terminal normal. Very useful on keyboards
" without a dedicated \ button
tnoremap <Esc> <C-\><C-n>
" }}}
" }}}
" Custom functions and commands {{{

" Super-cd {{{
" Super cd - changes the current working directory, as well as changing the NERDTree root
function! Scd(location)
    execute 'cd '.a:location
    execute 'NERDTree .'
endfunction

command! -nargs=1 -complete=dir Scd call Scd(<f-args>)
" }}}
" Compiler {{{

augroup Multiterm
    autocmd FileType cpp let g:tmux_multiterm_session = "cpp.0"
augroup END

fun! RunBuild(buildSys, allowEmpty, pane, ...)
    " buildSys: the command to use
    " allowEmpty: whether to allow the output to be inside vim. This will
    " block.

    " Runs a build command for a provided buildSys, channels into a provided
    " pipe, with optional args
    let args = ""
    if a:0 != 0
        let args = join(a:000)
    endif

    let base = a:buildSys . ' ' . args
    call TmuxSendKeys(a:pane, -1, base)
endfun

fun! RunBinary(buff, sess, ...)
    if a:0 == 0
        echo "Run what? (Supply a binary name)"
        return
    endif

    call TmuxSendKeys(a:buff, a:sess, './' . join(a:000, ' '))
endfun

fun! SetVEnv(...)
    let env = "env"
    if a:0 != 0
        let env = a:1
    endif
    let venv_load_script = getcwd() . '/' . env
    " Using python alters the current process, which is what we want.
    " Using `:!source <path>` doesn't work, because it spawns a new subprocess
    " that doesn't alter the parent. Python is a nice hack for fixing this,
    " and sourcing in the virtualenv
    python3 << EOF
import vim
activateThis = vim.eval('l:venv_load_script') + "/bin/activate_this.py"
if activateThis:
    exec(open(activateThis).read(), { "__file__": activateThis })
EOF
endfun

command! -nargs=* SCons call RunBuild('scons', 0, 0, '-j 6', <f-args>)
command! -nargs=* SConsTest call RunBuild('scons', 0, 1, 'test -j 6', <f-args>)

command! -nargs=? SetVEnv call SetVEnv(<f-args>)

nnoremap <leader>sco :SCons<cr>
nnoremap <leader>scot :SConsTest<cr>

command! -nargs=* Run call RunBinary(1, -1, <f-args>)

command! TmuxCpp let g:tmux_multiterm_session = 'cpp.0'

" }}}
" Utilities {{{
fun! IDeleteThis()
    silent !rm %
    :WintabsClose
endfun
command! DeleteThis call IDeleteThis()
" }}}

" }}}
" gVim config {{{
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
    " Bels are the _worst_
    autocmd GUIEnter * set vb t_vb=

    " This mapping only works in Vim. The alleged workarounds on the wiki do
    " not work
    imap <C-BS> <C-w>

    " hack: enable ctrl-ins and shift-ins.
    " These don't work out of the box on Ubuntu-based distros,
    " and possibly more distros. Works on Windows, ironically
    map <S-Insert> "+p
    imap <S-Insert> <Esc>"+p
    map <C-Insert> "+y
    imap <C-Insert> <Esc>"+y
endif
" }}}
" External config {{{
" This enables system-specific configurations that don't make sense to keep in
" the .vimrc (i.e. sensitive config, or config that is system-specific (i.e.
" startify bookmarks)).
if !isdirectory($HOME."/.vim-extern/")
    " Create the directory
    call mkdir($HOME."/.vim-extern")
else
    if filereadable($HOME."/.vim-extern/.systemrc")
        source $HOME/.vim-extern/.systemrc
    endif
endif
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
