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
    autocmd FileType markdown setlocal nofoldenable
augroup END
augroup config
    autocmd FileType markdown setlocal conceallevel=0
augroup END
" }}}
" System compatibility {{{
" Root code location
let g:ODevDir = 0
" Root 
let g:OVimDevDir = 0

if isdirectory("/mnt/LinuxData")
    let g:ODevDir = "/mnt/LinuxData/"
endif

if type(g:OVimDevDir) == v:t_number && type(g:ODevDir) == v:t_string
    " Assuming the general directory scheme is maintained anyway
    " Can be customized separately though.
    let g:OVimDevDir = g:ODevDir . 'programming/vim/'
endif

let g:Print = "Vimrc messages:\n"
fun! s:SilentPrint(message)
    let g:Print .= "\n" . a:message
endfun
command! Messages echo g:Print

fun! s:LocalOption(localPath, remotePath)
    if (type(g:OVimDevDir) == v:t_number || !isdirectory(g:OVimDevDir . a:localPath))
        exec "Plug '" . a:remotePath . "'"
        call s:SilentPrint("Using remote path: " . a:remotePath)
    else
        exec "Plug '" . g:OVimDevDir . a:localPath . "'"
        call s:SilentPrint("Using local path: " . g:OVimDevDir . a:localPath)
    endif
endfun

" }}}
" Plugins {{{
call plug#begin('~/.vim/plugged')
" Navigation {{{
Plug 'christoomey/vim-tmux-navigator'
Plug 'preservim/nerdtree'
Plug 'anschnapp/move-less'

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

Plug 'terryma/vim-expand-region'
" }}}
" Themes and colors {{{
Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/seoul256.vim'
Plug 'sonph/onehalf'
call s:LocalOption('Aurora', 'LunarWatcher/Aurora')
Plug 'rakr/vim-one'
Plug 'rakr/vim-two-firewatch'

" Colorscheme designer
call s:LocalOption('Amber', 'LunarWatcher/Amber')

Plug 'rhysd/conflict-marker.vim'

" Treesitter polyfill
call s:LocalOption('Acacia', 'LunarWatcher/Acacia')

" }}}
" GitHub integration {{{
call s:LocalOption('Skye', 'LunarWatcher/Skye.vim')
" }}}
" Language highlighting {{{
" Speed up load
let g:loaded_sensible = 1
Plug 'sheerun/vim-polyglot'

Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
Plug 'pboettch/vim-cmake-syntax'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'godlygeek/tabular'
Plug 'lervag/vimtex', {'for': 'tex'}
" }}}
" Various coding-related utils {{{
Plug 'scrooloose/nerdcommenter'
Plug 'liuchengxu/vista.vim'
Plug 'alvan/vim-closetag', {'for': ['markdown', 'html']}
Plug 'AndrewRadev/tagalong.vim', {'for': ['xml', 'html', 'xhtml', 'markdown']}
Plug 'tpope/vim-surround'

Plug 'mg979/vim-visual-multi'

" Codi isn't supported by Windows.
if !has("win32") && (has('job') && has('channel'))
    Plug 'metakirby5/codi.vim'
endif

Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asynctasks.vim'

call s:LocalOption('doctor.vim', 'LunarWatcher/doctor.vim')
" }}}
" Text extensions {{{
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'https://gitlab.com/dbeniamine/todo.txt-vim'
" }}}
" Coding utilities {{{
" Extended % matching
Plug 'chrisbra/matchit'

Plug 'rhysd/vim-clang-format'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'LunarWatcher/tmux-multiterm.vim'
" }}}
" Lightline {{{
Plug 'itchyny/lightline.vim'
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

call s:LocalOption('auto-pairs', 'LunarWatcher/auto-pairs')
call s:LocalOption('Dawn',       'LunarWatcher/Dawn')
call s:LocalOption('Pandora',    'LunarWatcher/Pandora')

Plug 'mbbill/undotree'

Plug 'puremourning/vimspector'

" }}}
" Search {{{
" This won't integrate with search preview
"Plug 'google/vim-searchindex'
Plug 'obcat/vim-hitspop'
Plug 'haya14busa/incsearch.vim'
Plug 'markonm/traces.vim'
Plug 'haya14busa/is.vim'
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
        if !has("gui_running")
            set guifont=Source\ Code\ Pro\ for\ Powerline\ 11
        else
            set guifont=Source\ Code\ Pro\ for\ Powerline:h11
        endif
    endif
endtry
" }}}
" Meta plugins {{{
Plug 'tweekmonster/startuptime.vim'
Plug 'thinca/vim-themis'

Plug 'tpope/vim-repeat'
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
    \ { 'type': 'bookmarks', 'header': ['    Bookmarks'] },
    \ { 'type': 'commands', 'header': ['    Commands'] },
    \ ]

let g:startify_files_number = 10

let g:startify_bookmarks = [
    \ {'c': '~/.vimrc'},
    \ ]
" }}}
" Autocomplete {{{

set shortmess+=c
set signcolumn=number
set updatetime=300

nmap <leader>qf  <Plug>(coc-fix-current)
inoremap <silent><expr> <c-space> coc#refresh()
nmap <leader>rn <Plug>(coc-rename)
nmap <silent> gd <Plug>(coc-definition)

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
" asyncrun and asynctask {{{
let g:asyncrun_open = 6
let g:asyncrun_bell = 0     " Fuck bells

nnoremap <F7> :call asyncrun#quickfix_toggle(6)<cr>

" That's a strong indicator vim on Windoze may resort to a different
" location, which would be a problem.
" So force compatibility by setting a custom config home.
" Admittedly, this is in parallel to the default one, but an attempt
" was made.
let g:asynctasks_extra_config = [ $HOME . "/.vim/asynctasks.ini" ]

" Shortcut mnemonic expander
" <leader>      prefix
"         r     namespace
"          b    build
"          r    run
" ------ Begin task list ------
"           c   C/C++ through make
"           jm  Java  through Maven
nnoremap <leader>rbc :AsyncTask cppbuild<cr>
nnoremap <leader>rrc :AsyncTask cpprun<cr>

" Java
nnoremap <leader>rbjm :AsyncTask mavenbuild<cr>

" Fuzzy finder integration
fun! s:FzfTaskSink(what)
    let p1 = stridx(a:what, '<')
    if p1 > -1
        let name = strpart(a:what, 0, p1)
        let name = substitute(name, '\v^\s*(.{-})\s*$', '\1', '')
        if name != ""
            exec "AsyncTask " . fnameescape(name)
        endif
    endif
endfun

fun! s:FzfAsyncTasks()
    let rows = asynctasks#source(&columns * 48 / 100)
    let source = []
    for row in rows
        let name = row[0]
        let source += [ name . ' ' . row[1] . ': ' . row[2] ]
    endfor
    let opts = {
        \ 'source': source,
        \ 'sink': function('s:FzfTaskSink'),
        \ 'options': '+m --nth 1 --inline-info --tac'
    \ }
    for key in keys(g:fzf_layout)
        let opts[key] = deepcopy(g:fzf_layout[key])
    endfor
    call fzf#run(opts)
endfun

command! -nargs=0 AsyncTaskFzf call s:FzfAsyncTasks()
nnoremap <leader>zt :AsyncTaskFzf<cr>

" }}}
" Vimspector {{{

let g:vimspector_enable_mappings = ''

nmap <M-d>c <Plug>VimspectorContinue
nmap <M-d>s <Plug>VimspectorStop
nmap <M-d>r <Plug>VimspectorRestart
nmap <M-d>e :VimspectorReset<cr>
nmap <M-d>p <Plug>VimspectorPause
nmap <leader>b <Plug>VimspectorToggleBreakpoint

" }}}
" Autopair config {{{

let g:AutoPairsShortcutFastWrap = "<C-f>"

let g:AutoPairsMapBS = 0
let g:AutoPairsMapCR = 1
let g:AutoPairsMultilineFastWrap = 1
let g:AutoPairsMultilineClose = 0
let g:AutoPairsCompatibleMaps = 0
let g:AutoPairsStringHandlingMode = 1
let g:AutoPairsPreferClose = 0

let g:AutoPairs = autopairs#AutoPairsDefine([
            \ {"open": '\w\zs<', "close": '>', "filetype": ["cpp", "java"]},
            \ {"open": "$", "close": "$", "filetype": "tex"},
            \ {"open": '\\left(', 'close': '\right)', "filetype": "tex"},
            \ {"open": '\vclass .{-} (: (.{-}[ ,])+)? ?\{', 'close': '};', 'mapopen': '{', 'filetype': 'cpp'},
            \ {"open": "*", "close": "*", "filetype": ["help"]},
            \ {"open": "|", "close": "|", "filetype": "help"},
            \ {'open': '\\[',  'close': '\]', "filetype": "tex"}
    \ ])

if has_key(g:AutoPairsLanguagePairs["html"], "<")
    unlet g:AutoPairsLanguagePairs["html"]["<"]
endif

let g:AutoPairsExperimentalAutocmd = 1

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
" Lightline {{{
let g:lightline = {
            \ 'colorscheme': 'one'
            \ }
" }}}
" Ultisnips {{{
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "CustomSnippets"]
let g:UltiSnipsExpandTrigger="<C-t>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"
let g:UltiSnipsListSnippets="<C-u>"
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
    \         'width': 0.7,
    \         'height': 0.7,
    \         'highlight': 'Type',
    \         'border': 'rounded'
    \     }
    \ }
let g:CopyPastaTemplate = g:fzf_layout["window"]
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit',
    \ 'ctrl-o': 'tabe'
\ }

command! -bang -nargs=? -complete=dir HFiles call fzf#run(fzf#wrap({
        \ 'source': 'ag --hidden --ignore .git -g ""',
        \ 'options': ['--layout=reverse'],
        \ 'window': g:CopyPastaTemplate
        \ }))

command! -bang -nargs=? -complete=dir HNGFiles call fzf#run(fzf#wrap({
        \ 'source': 'ag --hidden --skip-vcs-ignores --ignore .git -g ""',
        \ 'options': ['--layout=reverse'],
        \ 'window': g:CopyPastaTemplate
        \ }))

command! -bang -nargs=? -bang -complete=dir TODO call fzf#vim#ag("(TODO|FIXME):", {'options': ['--layout=reverse'], 'down': "30%"}, <bang>0)

nnoremap <leader>zx :HFiles<cr>
nnoremap <leader>zX :HNGFiles<cr>
nnoremap <leader>zb :TODO<cr>
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

" Show a search count
set shortmess-=S

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
    autocmd FileType text,markdown,tex setlocal wrap
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
vnoremap <Up> gk
vnoremap <Down> gj

" }}}
" Configure indents {{{
set cindent
set cino=N-s
set cino+=g0,l1
set cino+=(0
set cino+=k4,m1
" }}}
" Add non-standard filetypes {{{
augroup ZoeFiletypes
    au!

    autocmd BufRead,BufNewfile conanfile.txt set filetype=dosini
    autocmd BufRead,BufNewFile SConstruct set filetype=python
    autocmd Bufread,BufNewFile SConscript set filetype=python

    autocmd Bufread,BufNewFile *.trconf set ft=json
    autocmd BufRead,BufNewFile *.vert,*.frag set ft=glsl
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
" Visual {{{

set fillchars+=vert:\│
" }}}
" Filetype overrides {{{
if has("linux") && (has("gui_running") || $SSH_TTY == "")
    augroup ZoeGUIFiletypes
        au!
        
        autocmd BufRead *.png,*.jpg,*.jpeg call system('xdg-open ' . expand('%:p'))
    augroup END
endif
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
" Terminal {{{
tnoremap <C-n> <C-w>N
if has("gui_running")
    " Forward basic keys
    "https://old.reddit.com/r/vim/comments/cxhi7p/ctrlw_to_delete_word_in_terminal_window/
    tnoremap <C-BS> <C-w>.
    tnoremap <S-Space> <Space>
endif
"}}}
" Vimrc {{{
if empty($MYVIMRC)
    let $MYVIMRC = "~/.vimrc"
endif
nnoremap <leader>ve :split $MYVIMRC<cr>
nnoremap <leader>vE :e $MYVIMRC<cr>
nnoremap <leader>vt :tabe $MYVIMRC<cr>

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
    imap <buffer> <C-l><C-l> \lambda
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

    imap <buffer> <C-m>02 0 & 0
    imap <buffer> <C-m>03 0 & 0 & 0
    imap <buffer> <C-m>04 0 & 0 & 0 & 0
endfun


" }}}
" Filetype maps {{{
augroup FileMaps
    au!
    autocmd FileType tex call TexMaps()
augroup END
" }}}
" Custom movements {{{
" Delete Around Argument delete in word delete to find space
nnoremap daa diwdf<space>
" Not directly a movement, but close enough

nnoremap ø 0i
nnoremap æ ^i
" }}} 
" Copy-pasta {{{
command! -nargs=0 CopyLastCommand let @+ = @:
command! -nargs=+ -complete=command CopyCommandOutput redir @+ | <args> | redir END 

nnoremap <leader>ccp :CopyLastCommand<cr>
nnoremap <leader>csc q:
" }}}
" }}}
" Custom functions and commands {{{
" Fancy editing {{{
command! -nargs=1 E :e %:h/<args>
" }}}
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
command! -nargs=* TMake call RunBuild('make', 0, 0, '-j 12', <f-args>)

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

" Uncrustify {{{
let g:UncrustifyLanguageMap = {
    \ "cpp": "cpp"
    \ }

let g:UncrustifyConfig = ".uncrustify.cfg"

fun! UncrustifyRunner(config = g:UncrustifyConfig)
    " I could add error handling to the get, but fuck that
    " Don't be an idiot when you use this, future me
    let command = "uncrustify -q -c " . a:config . " -l " . g:UncrustifyLanguageMap[&ft]

    " Save the position
    let cursorPos = getpos('.')

    " Format
    silent! exec "%!" . command

    " Reset the cursor position
    call setpos('.', cursorPos)

endfun

command! -nargs=? UncrustifyFormat call UncrustifyRunner(<f-args>)

nnoremap <leader>uf :UncrustifyFormat<cr>
" }}}
" }}}
" gVim config {{{

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

if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p")
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p")
endif
" }}}
" vim:sw=4
