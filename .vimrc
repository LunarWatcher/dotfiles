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
    autocmd FileType markdown,vimwiki setlocal conceallevel=0
augroup END

" }}}
" Plugins {{{
call plug#begin('~/.vim/plugged')

" Navigation {{{
Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree'
Plug 'anschnapp/move-less'

Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'

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
    Plug 'junegunn/fzf', { 'do': './install --all' }
endif
Plug 'junegunn/fzf.vim'

fun! InstallClap(info)
    if a:info.status == "installed" || a:info.force
        :Clap install-binary
        call clap#installer#build_maple()
    endif
endfun

Plug 'liuchengxu/vim-clap', { 'do': function('InstallClap')}
Plug 'terryma/vim-expand-region'
" }}}

" Themes & colors {{{
Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/seoul256.vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'rakr/vim-one'
Plug 'rakr/vim-two-firewatch'

Plug 'pboettch/vim-cmake-syntax'
"Plug 'LunarWatcher/rainbow'

Plug 'RRethy/vim-illuminate'
Plug 'markonm/traces.vim'
" }}}

" Language highlighting {{{
Plug 'sheerun/vim-polyglot'
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'
Plug 'lervag/vimtex', {'for': 'tex'}
" }}}

" Various coding-related utils {{{
Plug 'scrooloose/nerdcommenter'
Plug 'liuchengxu/vista.vim'
Plug 'alvan/vim-closetag', {'for': ['markdown', 'html']}
Plug 'tpope/vim-surround'

Plug 'Yggdroot/indentLine'
Plug 'mg979/vim-visual-multi'
Plug 'Elive/vim-bling'

" Codi isn't supported by Windows.
if !has("win32") && (has('job') && has('channel'))
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

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'machakann/vim-Verdin'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"Plug 'airblade/vim-gitgutter'

"Plug '/mnt/LinuxData/programming/vim/tmux-multiterm.vim'
if !has("nvim")
    Plug 'LunarWatcher/tmux-multiterm.vim'
endif
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
if !isdirectory('/mnt/LinuxData/programming/vim/auto-pairs')
    Plug 'LunarWatcher/auto-pairs'
else
    Plug '/mnt/LinuxData/programming/vim/auto-pairs'
endif
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

        set guifont=SauceCodePro\ Nerd\ Font\ 12
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

" Meta plugins {{{
Plug 'thinca/vim-themis'
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
" vim-visual-multi config {{{

nmap   <C-LeftMouse>         <Plug>(VM-Mouse-Cursor)
nmap   <C-RightMouse>        <Plug>(VM-Mouse-Word)
nmap   <M-C-RightMouse>      <Plug>(VM-Mouse-Column)
" }}}
" Start screen config {{{
function! s:center(lines)
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
" Autocomplete {{{

let g:Verdin#autocomplete = 1

set shortmess+=c
set signcolumn=number
set updatetime=300


nmap <leader>qf  <Plug>(coc-fix-current)
inoremap <silent><expr> <c-space> coc#refresh()
nmap <leader>rn <Plug>(coc-rename)

" Fix scrolling in popups
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Show docs
" I also like that this doesn't show up automatically. YCM was wayyyyyyyy too
" aggressive in showing documentation.
nnoremap <silent> K :call CocActionAsync('doHover')<cr>

" Restarting is the only way to fix an issue with some popups not
" disappearing. Focusing and quitting the popup could also be an option, but
" fuuuuuuuck that
nnoremap <silent> <leader>rc :call CocRestart<cr>
nnoremap <silent> <leader>hp :call coc#float#close_all()<cr>

" }}}
" Autopair config {{{

let g:AutoPairsShortcutFastWrap = "<C-f>"
" Disable BS for pair deletion
let g:AutoPairsMapBS = 0
let g:AutoPairsMapCR = 1
let g:AutoPairsMultilineFastWrap = 1
let g:AutoPairsMultilineClose = 0
let g:AutoPairsCompatibleMaps = 0


let g:AutoPairs = autopairs#AutoPairsDefine([
            \ {"open": '\w\zs<', "close": '>'},
            \ {"open": "$", "close": "$", "filetype": "tex"},
            \ {"open": '\\left(', 'close': '\right)', "filetype": "tex"},
            \ {"open": '\vclass .{-} (: (.{-}[ ,])+)? ?\{', 'close': '};', 'mapopen': '{', 'filetype': 'cpp'},
    \ ])
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
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "CustomSnippets"]
let g:UltiSnipsExpandTrigger="<C-t>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"
let g:UltiSnipsListSnippets="<C-u>"
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
" Sessions {{{
let g:session_autosave = 'no'
let g:session_autoload = 'no'

nnoremap <leader>ss :SaveSession<cr>
nnoremap <leader>sl :LoadSession<cr>

set sessionoptions-=help

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

" The autocmd enabling this for some files failed.
let g:rainbow_active = 1
let g:rainbow_list = ['vim', 'javascript', 'java', 'python', 'cpp']
" }}}
" FZF {{{ "
let g:fzf_layout = {
    \ 'window':
    \     {
    \         'width': 0.9,
    \         'height': 0.6,
    \         'highlight': 'Todo',
    \         'border': 'sharp'
    \     }
    \ }

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
nnoremap <leader>qt :WintabsClose<cr>

let g:wintabs_ui_vimtab_name_format = ' %n %t '
" }}}
" Plasticboy markdown {{{
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_folding_disabled = 1
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

set scrolloff=5           " Lines over and under the cursor when scrolling

set list
set listchars=tab:→\ ,nbsp:•

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
" Configure wrapping {{{
" Wrapping is disabled by default, but it's still used in a few places because
" it does have practical uses.
" Of course, though, there's config to make it less crap :D
augroup CustomWrap
    au!
    autocmd FileType text,markdown,vimwiki,tex setlocal wrap
augroup END
" I don't remember what this is for
set linebreak
" Indent broken lines
set breakindent
" Highlight broken lines
set showbreak=>>
" Remove @ on wrapped lines
set display=lastline

" Wrap maps
inoremap <C-up> <C-o>g<up>
inoremap <C-down> <C-o>g<down>

nnoremap <Up> gk
nnoremap <Down> gj

" }}}
" Configure indents {{{
set cindent
set cino=N-s
set cino+=g0,l1
set cino+=(0
set cino+=k4,m1
" }}}
" Add non-standard filetypes {{{
augroup Filetypes
    au!

    autocmd BufRead,BufNewfile conanfile.txt set filetype=dosini
    autocmd BufRead,BufNewFile SConstruct set filetype=python
    autocmd Bufread,BufNewFile SConscript set filetype=python

    autocmd Bufread,BufNewFile *.trconf set ft=json
augroup END
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

augroup TabConf
    au!
    " Make is specific about using tabs
    autocmd FileType make setlocal noexpandtab
    autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2

augroup END

" }}}
" Cursor config {{{
if has("gui_running")
    hi iCursor guibg=#e00d93
    hi Cursor  guibg=purple
    hi Visual  guibg=#b19cd9
    set guicursor=n-v-c:block-Cursor-blinkon530-blinkwait530-blinkoff530
    set guicursor+=i:ver20-iCursor-blinkon530-blinkwait530-blinkoff530
endif
" This is meant to be terminal-compatible
" Doesn't work, though
"let &t_SI="\e[5 q"
"let &t_SR="\e[4 q"
"let &t_EI="\e[5 q"
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

" Get tab maps on the mouse in normal mode
nmap <X2Mouse> <C-PageDown>
nmap <X1Mouse> <C-PageUp>

" }}}
" LaTeX {{{
fun! TexMaps()
    if !has("gui_running")
        echoerr "LaTeX-maps are gvim-specific, and aren't compatible with terminal vim"
        return
    endif

    " Matrix helpers
    " .<bs> is a trick for forcing <cr> to work at the end of a map with no
    " delay (might be a consequence of a <cr> map, but iDunno
    imap <buffer> <C-CR> <space>\\<cr>.<bs>
    imap <buffer> <S-CR> <C-o>$<space>\\<CR>.<bs>
    imap <buffer> <C-Tab> <space>&<space>
    imap <buffer> <S-Tab> <C-o>$<space>&<space>
    imap <buffer> <C-e><C-e> <space>\\<space>

    " Icon helpers
    imap <buffer> <C-l><C-b> \mathbb{}<left>
    imap <buffer> <C-l><C-l> \mathcal<space>
    imap <buffer> <C-l><C-.> \cdot
    imap <buffer> <C-l><C-s> _{}<left>
    imap <buffer> <C-l><C-r> \sqrt{}<left>
    " Various alignments
    imap <buffer> <C-l><C-a> \begin{align*}<CR>.<CR>\end{align*}<up><C-o>$<BS>
    imap <buffer> <C-l><C-m> \begin{bmatrix}\end{bmatrix}<C-o>14<left><C-o>:call search('\\end')<cr>
    imap <buffer> <C-l><C-t> \begin{tmatrix}{}\end{tmatrix}<C-o>16<Left><C-o>:call search('{')<cr><right>
    imap <buffer> <C-l><C-o> \begin{oppgave}<CR>\begin{punkt}<CR>.<CR>\end{punkt}<cr>\end{oppgave}<up><up><C-o>$<BS>
    imap <buffer> <C-l><C-p> \begin{punkt}<CR>.<CR>\end{punkt}<up><C-o>$<BS>

    imap <buffer> <C-e>2 ^2
    imap <buffer> <C-e>g ^{}<left>
    " Expressions
    imap <buffer> <C-e><C-s> Sp\left\{\right\}<left><C-o>%<C-o>7<right>
    imap <buffer> <C-e><C-t> <C-o>$<space>\text{} \\<left><left><left><left>
    " Expand inside a block
    " Indentation preservation works by making sure the line has been edited.
    " Prevents vim from removing whitespace for some reason.
    imap <buffer> <C-l><C-e> <CR>.<bs><CR><up><tab><C-o>$

    " Default matrices
    imap <buffer> <C-m>2 \begin{bmatrix} x \\ y \end{bmatrix}
    imap <buffer> <C-m>3 \begin{bmatrix} x \\ y \\ z \end{bmatrix}
    imap <buffer> <C-m>4 \begin{bmatrix} x \\ y \\ z \\ w \end{bmatrix}
    " Default numeric matrices
    imap <buffer> <C-m>n2 \begin{bmatrix} 0 \\ 0  \end{bmatrix}
    imap <buffer> <C-m>n3 \begin{bmatrix} 0 \\ 0  \\ 0 \end{bmatrix}
    imap <buffer> <C-m>n4 \begin{bmatrix} 0 \\ 0  \\ 0 \\ 0 \end{bmatrix}
    " Basis for R^2
    imap <buffer> <C-m>x2 \begin{bmatrix} 1 \\ 0 \end{bmatrix}
    imap <buffer> <C-m>y2 \begin{bmatrix} 0 \\ 1 \end{bmatrix}
    " Basis for R^3
    imap <buffer> <C-m>x3 \begin{bmatrix} 1 \\ 0 \\ 0 \end{bmatrix}
    imap <buffer> <C-m>y3 \begin{bmatrix} 0 \\ 1 \\ 0 \end{bmatrix}
    imap <buffer> <C-m>z3 \begin{bmatrix} 0 \\ 0 \\ 1 \end{bmatrix}
    " Basis for R^4
    imap <buffer> <C-m>x4 \begin{bmatrix} 1 \\ 0 \\ 0 \\ 0 \end{bmatrix}
    imap <buffer> <C-m>y4 \begin{bmatrix} 0 \\ 1 \\ 0 \\ 0 \end{bmatrix}
    imap <buffer> <C-m>z4 \begin{bmatrix} 0 \\ 0 \\ 1 \\ 0 \end{bmatrix}
    imap <buffer> <C-m>w4 \begin{bmatrix} 0 \\ 0 \\ 0 \\ 1 \end{bmatrix}
endfun


" }}}
" Filetype maps {{{
augroup FileMaps
    au!
    autocmd FileType tex call TexMaps()
augroup END
" }}}
" }}}
" Custom functions and commands {{{

" Renaming tabs {{{
fun! RenameTab(newName)
    " This is compatible with the buffertab plugin I use.
    " It's perfectly possible to set other variables for custom use, but the
    " plugin uses t:label.
    " Seems awfully prone to conflicts though.
    let t:label = a:newName
endfun
command! -nargs=1 RenameTab call RenameTab(<f-args>)
" }}}

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
" Profiling {{{
fun! s:profileStart()
    profile start profile.log
    profile func *
    profile file *
endfun
fun! s:profileStop()
    profile pause
    noautocmd qall!
endfun

command! StartProfile call s:profileStart()
command! StopProfile call s:profileStop()

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
    " Bells are the _worst_
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

" Persistent undo
set undofile

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
