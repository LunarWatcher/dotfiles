" Base configuration {{{
" Encoding. Required for powerline fonts (at least with gVim: https://vi.stackexchange.com/q/20136/21251)
" Might be dependent on window-specific overrides.
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set nocompatible              " be iMproved, required
filetype off                  " required

let g:ODebugVim = 0

if g:ODebugVim
    call ch_logfile($HOME .. "/.log/vim-" .. strftime("%FT%T") .. ".txt", "ao")
endif

if has("win32unix")
    finish
endif

let g:python3_host_prog = 'python3'
" }}}
" Folding {{{
set foldmethod=marker
" set nofoldenable

nnoremap <leader>ft :set foldenable!
nnoremap <leader>fe :set foldenable
nnoremap <leader>fd :set nofoldenable

augroup folding
    au!
    autocmd FileType vim setlocal foldenable
    autocmd FileType markdown setlocal nofoldenable
augroup END
augroup config
    au!
    autocmd FileType markdown setlocal conceallevel=0
augroup END
augroup SpecialFiles
    au!
    autocmd FileType fern call glyph_palette#apply()
    autocmd FileType fall-list call glyph_palette#apply()
    autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
" }}}
" System compatibility {{{
" Root code location
let g:ODevDir = 0
" Root 
let g:OVimDevDir = 0

if isdirectory("/mnt/LinuxData")
    let g:ODevDir = "/mnt/LinuxData/"
elseif isdirectory($HOME .. "/programming/vim")
    let g:ODevDir = $HOME .. "/"
elseif $SSH_TTY != ""
    let g:ODevDir = $HOME .. "/"
    let g:OVimDevDir = g:ODevDir .. "programming/"
endif

if type(g:OVimDevDir) == v:t_number && type(g:ODevDir) == v:t_string
    " Assuming the general directory scheme is maintained anyway
    " Can be customized separately though.
    let g:OVimDevDir = g:ODevDir .. 'programming/vim/'
endif

let g:Print = "Vimrc messages:\n"
fun! s:SilentPrint(message)
    let g:Print ..= "\n" .. a:message
endfun
command! Messages echo g:Print

fun! s:LocalOption(localPath, remotePath)
    if (type(g:OVimDevDir) == v:t_number || !isdirectory(g:OVimDevDir .. a:localPath))
        exec "Plug '" .. a:remotePath .. "'"
        call s:SilentPrint("Using remote path: " .. a:remotePath)
    else
        exec "Plug '" .. g:OVimDevDir .. a:localPath .. "'"
        call s:SilentPrint("Using local path: " .. g:OVimDevDir .. a:localPath)
    endif
endfun

" }}}
" Plugins {{{
call plug#begin('~/.vim/plugged')
" Local debug {{{
if isdirectory(g:OVimDevDir .. "PluginScience")
    exec "Plug '" .. g:OVimDevDir .. "PluginScience" .. "'"
endif
" }}}
" Navigation {{{
"call s:LocalOption("fern.vim", "LunarWatcher/fern.vim")
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'

" Required for vim-fern-renderer-nerdfont to work
Plug 'lambdalisue/vim-nerdfont'
Plug 'lambdalisue/vim-fern-renderer-nerdfont'
Plug 'lambdalisue/vim-glyph-palette'

if executable("git")
    Plug 'lambdalisue/vim-fern-git-status'
endif

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

" }}}
" Themes and colors {{{
" Temporary until https://github.com/NLKNguyen/papercolor-theme/pull/203 is
" merged
call s:LocalOption("papercolor.vim", "LunarWatcher/papercolor.vim")
" Plug 'NLKNguyen/papercolor-theme'

Plug 'rhysd/conflict-marker.vim'

" }}}
" Language highlighting {{{
" Speed up load
let g:loaded_sensible = 1
Plug 'sheerun/vim-polyglot'

Plug 'bfrg/vim-c-cpp-modern', {'for': 'cpp'}
Plug 'preservim/vim-markdown', { 'for': 'markdown' }
Plug 'godlygeek/tabular'
Plug 'lervag/vimtex', {'for': 'tex'}
" }}}
" Various coding-related utils {{{
Plug 'preservim/nerdcommenter'
Plug 'liuchengxu/vista.vim'
Plug 'tpope/vim-surround'

Plug 'mg979/vim-visual-multi'

"Plug 'skywind3000/asyncrun.vim'
"Plug 'skywind3000/asynctasks.vim'

" Primarily used at work, and in some large open-source projects 
Plug 'editorconfig/editorconfig-vim'
" }}}
" Text extensions {{{
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/vim-easy-align'
Plug 'wellle/targets.vim'
" Bit of a weak argument to call this a text extension, but here we are
" Plug 'junegunn/vim-peekaboo'
call s:LocalOption("img-paste.vim", "LunarWatcher/img-paste.vim")
" }}}
" Coding utilities {{{
" Extended % matching
Plug 'chrisbra/matchit'

Plug 'rhysd/vim-clang-format'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

if has("python3")
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    " I had to give this a double name because
    " 1. I'm lazy
    " 2. just vim-snippets results in vim-plug not being sure what to do with
    "    honza/vim-snippets, because BrOKeN InstALlAtion.
    "    Would be a lot easier if vim-plug preserved the username in the path.
    " 3. Telling people to manually rename either repo with plugin manager
    "    config is stupid
    call s:LocalOption("lunarwatcher-vim-snippets", 'LunarWatcher/lunarwatcher-vim-snippets')
endif
" }}}
" Lightline {{{
" Plug 'itchyny/lightline.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" }}}
" Git integration {{{
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'airblade/vim-gitgutter'
" }}}
" Project management {{{
Plug 'embear/vim-localvimrc'
call s:LocalOption("LightSessions.vim", "LunarWatcher/LightSessions.vim")
" }}}
" General every-day use {{{
Plug 'tpope/vim-speeddating'
Plug 'scy/vim-mkdir-on-write'

call s:LocalOption('auto-pairs', 'LunarWatcher/auto-pairs')
call s:LocalOption('Dawn',       'LunarWatcher/Dawn')

Plug 'mbbill/undotree'

if !has("win32") && !has("win32unix")
    Plug 'puremourning/vimspector'
endif
" }}}
" Search {{{
Plug 'obcat/vim-hitspop'
Plug 'markonm/traces.vim'
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
        " Up since 2018, "patched" in 2020
        " As of 2022, it's still broken.
        "set guifont=SauceCodePro\ NF:h11
        " ... and to add insult to injury, as of 2022, the powerline variant
        " does not display properly. No fucking clue what the problem is, but
        " it looks like no anti-aliasing or something? Fuck if I know. All I
        " know is that it's hideous to look at, and painfully hard to read
        "set guifont=Source\ Code\ Pro\ for\ Powerline:h11
        " The point in any case... default SCP
        " Thanks for nothing, Windows
        set guifont=Source\ Code\ Pro:h12
    elseif has("unix")
        set guifont=SauceCodePro\ Nerd\ Font\ 12
        Plug 'ryanoasis/vim-devicons'
    endif
catch
    echom "Failed to find SauceCodePro - falling back to SourceCodePro, and disabling devicons"
    if has("win32")
        " We were supposed to fall back to powerline if we didn't have nerd
        " fonts, but that likely being pointless aside (on linux installs, the
        " font always exists), we have nothing to fall back on.
        "
        " We could fall back on plain SCP here, but we can't do that now that
        " SCP is the only workin font on this godforesaken shitty OS. (Why am
        " I even doing this to myself?)
        echoerr "Options exhausted; install Source Code Pro directly"
    elseif has("unix")
        if !has("gui_running")
            set guifont=Source\ Code\ Pro\ for\ Powerline\ 12
        else
            set guifont=Source\ Code\ Pro\ for\ Powerline:h12
        endif
    endif
endtry
" }}}
" Meta plugins {{{
"Plug 'tweekmonster/startuptime.vim'
Plug 'thinca/vim-themis'

Plug 'tpope/vim-repeat'
call s:LocalOption("helpwriter.vim", "LunarWatcher/helpwriter.vim")
call s:LocalOption("vim9cord", "LunarWatcher/vim9cord")
call s:LocalOption("vimrc-modules", "LunarWatcher/vimrc-modules")
" }}}
call plug#end()
" }}}
" Plugin config {{{
" Vim9cord (testing) {{{
"let g:Vim9cordButtons = [
    "{}
"]

let g:Vim9cordAltDetails = "I don't have a problem, I can quit any time I want :3"
" }}}
" Plug mapping {{{
nnoremap <leader>pi <esc>:PlugInstall<cr>
nnoremap <leader>pc <esc>:PlugClean<cr>
if !has("win32")
    nnoremap <leader>pu :PlugUpdate<cr>:CocUpdate<cr>:VimspectorUpdate<cr>
else
    " Vimspector is not supported on windows
    nnoremap <leader>pu :PlugUpdate<cr>:CocUpdate<cr>
endif
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
            \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) .. v:val')
    return centered_lines
endfunction

let g:startify_custom_header = s:center([
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⠟⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣶⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⠏⣿⠀⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠉⢿⡻⠙⠦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡞⠛⠃⢠⣷⡀⠈⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠘⣷⡄⠀⠈⠙⢦⡴⣶⠖⠋⠑⠋⠉⠛⢷⣄⡀⣾⠋⣹⡷⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡄⢀⡿⢷⡄⢠⣾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣄⣹⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⡛⣶⠄⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠙⢮⡿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢷⢻⣺⠇⠀⠀⠀⠀⣶⣦⠀⠀⠀⢻⠿⢀⣤⣤⣄⠀⠀⠙⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣽⡯⠀⠀⣤⣤⣤⡙⠋⠀⠀⠀⠀⠀⣾⠛⣿⣿⣿⠃⠀⣩⣷⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠠⣾⣿⣿⠛⢿⡄⠀⣀⣀⣀⠀⢿⣿⣿⣿⣟⡴⠟⢙⣪⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣭⣀⠀⠈⢿⣿⣿⣿⣧⠞⠛⣿⢉⠙⠛⠛⣿⡍⠁⠀⠀⣠⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣮⡎⠙⠓⠲⠛⣿⡍⠀⠀⠀⠙⠏⠀⠀⠀⠉⠁⠀⣀⡴⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⢶⣄⠀⠀⠈⠁⢀⠀⣠⣀⣤⢶⠀⠀⣶⠒⠻⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⣹⡟⢿⡿⠀⡾⠀⠷⢀⠙⢀⡛⣦⠀⠸⣗⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⠅⣿⠼⠀⠠⡧⠀⠘⠂⠀⠹⣾⠆⠀⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⣸⣏⣰⢧⡄⠀⠀⠀⠀⠀⠀⣿⡄⠀⠸⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠁⣸⡏⠉⠉⠀⠀⠀⠀⠀⠀⠰⣿⠁⠀⢀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠤⠤⠤⢤⣄⣀⠀⢰⣇⠀⠻⣶⠀⠀⠀⠀⠀⠀⠀⠀⢰⠟⠀⠀⢸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⣴⠞⠛⠀⠀⠀⠀⠀⣆⡏⢹⠏⣟⠀⠀⠈⠳⣶⣆⠀⠀⠀⣦⣠⠟⠀⠀⠀⢀⡟⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⢀⡞⠁⠀⢰⣟⡻⠿⠷⠤⢤⣴⣏⣸⢽⣶⠀⠀⠀⠈⠛⢦⣠⡴⠋⠁⠀⠀⠀⢰⠿⣿⣽⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⢠⡿⠀⠀⠀⠀⠉⠀⠀⠀⣰⠞⣉⠀⠉⠳⢿⣦⡄⠀⢀⣠⣿⡇⣷⡀⠈⠀⠀⢀⡏⠀⠀⠀⠈⢳⡀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⣼⠓⠄⠀⠀⠀⠀⢀⣤⠾⢃⣀⠠⠤⠀⠀⠀⠙⢿⣶⣿⣿⣿⡇⣿⣿⣿⣄⣴⣾⠃⣀⣤⡉⠀⠈⢳⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⢻⠃⠀⠀⠀⠀⢠⡟⠁⣠⡀⢠⡄⠲⠆⠀⠀⠀⠀⢹⣿⣿⣿⡇⣿⣷⣿⣟⢍⡏⠀⠳⡿⠃⠀⠀⢸⠂⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠸⣆⠀⠀⠀⠀⠘⢧⡀⠀⢠⣄⠶⠆⠀⠀⠀⠀⠀⠀⢻⣿⣿⡇⣿⣿⣿⣿⣿⣇⣀⣀⠀⠀⣠⢠⡾⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠘⢷⡀⠀⠀⠀⣼⠋⠓⠀⢠⣤⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⡧⣿⣿⣿⣾⢷⣿⣿⣿⣷⣾⠾⠋⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠉⠓⠦⣄⣹⣼⠆⠹⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣿⣿⣧⣿⣿⣿⠏⠀⠉⠛⠛⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ',
    \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠙⠛⠛⠛⠓⠒⠒⠲⠤⢬⡏⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     '
\ ])

let g:startify_lists = [
    \ { 'type': function('lightsessions#StartifyList'),  'header': ['    Sessions'] },
    \ { 'type': 'bookmarks', 'header': ['    Bookmarks'] },
    \ { 'type': 'commands',  'header': ['    Commands'] },
    \ ]

let g:startify_files_number = 10

let g:startify_bookmarks = [
    \ {'c': '~/.vimrc'},
    \ {'z': '~/.zshrc'},
    \ {'a': '~/.shell_aliases'},
    \ ]
" }}}
" Autocomplete {{{

set shortmess+=c
set signcolumn=yes
set updatetime=100

let g:coc_global_extensions = [
    \ 'coc-tsserver', 'coc-css', 'coc-html',
    \ 'coc-clangd',
    \ 'coc-snippets',
    \ 'coc-jedi'
\ ]
nmap <leader>qa  <Plug>(coc-codeaction-cursor)
nmap <leader>qs  <Plug>(coc-codeaction-source)
nmap <leader>qf  <Plug>(coc-fix-current)

inoremap <silent><expr> <c-space> coc#refresh()
nmap <leader>rn <Plug>(coc-rename)
nmap <silent> <leader>rd <Plug>(coc-definition)
nmap <silent> <leader>rD <Plug>(coc-declaration)
nmap <silent> <leader>rr <Plug>(coc-references)
nmap <silent> <leader>ri <Plug>(coc-implementation)
nmap <silent> <leader>rt <Plug>(coc-type-definition)

nmap <silent> <leader>rf <Plug>(coc-format)

" Fix scrolling in popups
nnoremap <silent><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"


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
" Vimspector {{{
if !has("win32") && !has("win32unix")
    let g:vimspector_enable_mappings = ''
    let g:vimspector_install_gadgets = [ "vscode-cpptools", "vscode-js-debug" ]

    nmap <leader>dc <Plug>VimspectorContinue
    nmap <leader>ds <Plug>VimspectorStop
    nmap <leader>dR <Plug>VimspectorRestart
    nmap <leader>dr :VimspectorReset<cr>
    nmap <leader>dp <Plug>VimspectorPause
    nmap <leader>db :call vimspector#Launch()<cr>

    nmap <leader>bb <Plug>VimspectorToggleBreakpoint
    nmap <leader>bc <Plug>VimspectorToggleConditionalBreakpoint
    nmap <Leader>bl <Plug>VimspectorBreakpoints

    nmap <leader>dl :execute 'VimspectorLoadSession /tmp/' .. fnamemodify(getcwd(), ':t') .. '.session'<CR>
    nmap <leader>dm :execute 'VimspectorMkSession /tmp/' .. fnamemodify(getcwd(), ':t') .. '.session'<CR>
endif
" }}}
" Autopair config {{{

let g:AutoPairsShortcutFastWrap = "<C-f>"

let g:AutoPairsMapBS = 0
let g:AutoPairsMapCR = 1
let g:AutoPairsMultilineFastWrap = 1
let g:AutoPairsMultilineClose = 0
let g:AutoPairsCompatibleMaps = 0
let g:AutoPairsStringHandlingMode = 2
let g:AutoPairsPreferClose = 0

call autopairs#Variables#InitVariables()

let g:AutoPairs = autopairs#AutoPairsDefine([
            \ {"open": '\w\zs<', "close": '>', "filetype": ["cpp", "java"]},
            \ {"open": "$", "close": "$", "filetype": "tex"},
            \ {"open": '\left(', 'close': '\right)', "filetype": "tex"},
            \ {"open": '\vclass .{-} (: (.{-}[ ,])+)? ?\{', 'close': '};', 'mapopen': '{', 'filetype': 'cpp', 'regex': 1},
            \ {"open": "*", "close": "*", "filetype": ["help"]},
            \ {"open": "|", "close": "|", "filetype": "help"},
    \ ])
"let g:AutoPairs = autopairs#AutoPairsDefine([{'open': '\\(', 'close': '\)', 'filetype': 'tex'}])

if has_key(g:AutoPairsLanguagePairs["html"], "<")
    unlet g:AutoPairsLanguagePairs["html"]["<"]
endif

let g:AutoPairsExperimentalAutocmd = 1
" }}}
" Undotree {{{
nnoremap <leader>ou :UndotreeToggle<cr>
" }}}
" Local vimrc {{{
let g:localvimrc_ask = 0
let g:localvimrc_sandbox = 0

set exrc
" }}}
" Lightline {{{
"let g:lightline = {
"            \ 'colorscheme': 'one'
"            \ }
" }}}
" Airline {{{
let g:airline_theme = "bubblegum"
let g:airline_powerline_fonts = 1
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
" FZF {{{ 
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
let $FZF_DEFAULT_OPTS="--bind ctrl-a:select-all"
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit',
    \ 'ctrl-o': 'tabe',
\ }

command! -bang -nargs=? -complete=dir HFiles call fzf#run(fzf#wrap({
        \ 'source': "rg --hidden --glob '!.git' --files",
        \ 'options': ['--layout=reverse'],
        \ 'window': g:CopyPastaTemplate
        \ }))

command! -bang -nargs=? -complete=dir HNGFiles call fzf#run(fzf#wrap({
        \ 'source': "rg --hidden --no-ignore-vcs --glob '!.git' --files",
        \ 'options': ['--layout=reverse'],
        \ 'window': g:CopyPastaTemplate
        \ }))

command! -bang -nargs=? -complete=dir CMakeFiles call fzf#run(fzf#wrap({
        \ 'source': 'rg --hidden --ignore .git -g "CMakeLists.txt"',
        \ 'options': ['--layout=reverse'],
        \ 'down': '30%'
        \ }))

command! -nargs=0 TODO grep! '(TODO\|FIXME)(\(.*\))?:?'

" Note to self: the documentation lies
" sinklist here forces a fallback 
command! -bang -nargs=* Search call fzf#vim#grep2(
        \ "rg --hidden --glob '!.git' --column --line-number --no-heading --color=always --smart-case -- ", 
        \ <q-args>,
        \ {
        \   'options': [
        \       '--layout=reverse', 
        \       '--bind=enter:select-all+accept',
        \       '--multi',
        \   ],
        \   'down': '30%',
        \ },
        \ <bang>0
        \ )

fun! s:AddCoAuthors(lines)
    call map(a:lines, '"Co-Authored-By: " .. v:val')
    " Force insertion on the current line and out rather than inserting a
    " potentially blank line
    call append(line('.') - 1, a:lines)
endfun
command! -bang -nargs=* AddGitCoAuthors call fzf#run(fzf#wrap({
    \ 'source': "git log --format='%aN <%aE>' | sort -u",
    \ 'down': '30%',
    \ 'sinklist': function('s:AddCoAuthors')
\ }), <bang>0)
augroup GitCoAuthorHelper
    au! 
    autocmd FileType gitcommit nnoremap <buffer> <leader>co :AddGitCoAuthors<cr>
augroup END

" Modified version of fzf.vim's :Rg and :RG that includes hidden files, while
" omitting .git. Necessary for several very relevant files to be searchable
command! -bang -nargs=* HRg call fzf#vim#grep("rg --hidden --glob '!.git' --column --line-number --no-heading --color=always --smart-case -- ".fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* HRG call fzf#vim#grep2("rg --hidden --glob '!.git' --column --line-number --no-heading --color=always --smart-case -- ", <q-args>, fzf#vim#with_preview(), <bang>0)

nnoremap <leader>zx :HFiles<cr>
nnoremap <leader>zX :HNGFiles<cr>
nnoremap <leader>zc :HRg<cr>
nnoremap <leader>zC :HRG<cr>
nnoremap <leader>zb :TODO<cr>
nnoremap <leader>zs :Search<cr>

nnoremap <leader>ocm :CMakeFiles<cr>

" Remap some of the defaults {{{
nnoremap <leader>zh :Helptags<cr>
" }}}
" }}} FZF
" fern.vim {{{
" Global settings
let g:fern#disable_default_mappings = 1
let g:fern#default_hidden = 1
let g:fern#disable_drawer_smart_quit = 1
let g:fern#drawer_width = 32
let g:fern#default_hidden = 1
let g:fern#renderer = "nerdfont"
let g:fern#renderer#nerdfont#indent_markers = 1

let g:nerdfont#autofix_cellwidths = 1

" Global control mappings
nnoremap <F2> :Fern . -drawer -stay -toggle<cr>

"let g:fern#loglevel = g:fern#DEBUG
fun FernMaps()

    nmap <buffer><expr> <Plug>(fern-cr)
        \ fern#smart#leaf(
            \ "<Plug>(fern-action-open)",
            \ "<Plug>(fern-action-expand:stay)",
            \ "<Plug>(fern-action-collapse)",
        \ )
    
    " This is common sense, why isn't this default?
    nmap <buffer> <CR> <Plug>(fern-cr)
    nmap <buffer> <2-LeftMouse> <Plug>(fern-cr)
    
    " Nerd-tree compatible mappings
    nmap <buffer> s <Plug>(fern-action-open:vsplit)
    nmap <buffer> h <Plug>(fern-action-open:split)
    nmap <buffer> t <Plug>(fern-action-open:tabedit)

    nmap <buffer> o <Plug>(fern-cr)
    nmap <buffer> O <Plug>(fern-action-expand-tree:stay)
    nmap <buffer> L <Plug>(fern-action-expand-tree:in)

    " Filesystem maps
    nmap <buffer> M <Plug>(fern-action-move)
    nmap <buffer> C <Plug>(fern-action-copy)
    
    nmap <buffer> N <Plug>(fern-action-new-path)
    nmap <buffer> T <Plug>(fern-action-new-file)
    nmap <buffer> D <Plug>(fern-action-new-dir)

    nmap <buffer> dd <Plug>(fern-action-remove)
    nmap <buffer> cd <Plug>(fern-action-enter)

    " Fern-specific maps
    nmap <buffer> <leader> <Plug>(fern-action-mark)

    " Meta maps
    nmap <buffer> <F5> <Plug>(fern-action-reload)
endfun
" }}}
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
let g:vimtex_compiler_clean_paths = ['_minted*']
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
" }}}
" Easy align {{{
nmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)
" }}}
" }}}
" Formatter config {{{
let g:html_indent_style1 = "inc"

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
if has("patch-8.2.4325")
    set wildoptions=pum
end

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
    " I still find it funny  that I haven't touched this part of my vimrc
    " since I wrote it, and I have yet to use a single terminal where
    " termguicolors has been unavailable.
    set termguicolors         " Required for true color terminals. If statement for compat
else
    set t_Co=256
endif

" Fix backspace issues
set backspace=indent,eol,start " backspace over everything in insert mode"
" Fix that horrid arrow nav issue
set whichwrap+=<,>,h,l,[,]

" Welcome to 2024
set smoothscroll
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
set cino+=k4,m1,W4,j1
" }}}
" Add non-standard filetypes {{{
augroup ZoeFiletypes
    au!

    autocmd BufRead,BufNewfile conanfile.txt set filetype=dosini.conanfile

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
"colorscheme two-firewatch
"colorscheme Aurora

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

    autocmd FileType typescript,typescriptreact,javascriptreact setlocal sw=2 tabstop=2 softtabstop=2

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

set fillchars+=eob:\ ,vert:\│
" }}}
" Session management {{{
" Storing options is a shit idea: https://github.com/LunarWatcher/auto-pairs/issues/33
set ssop-=options,globals,localoptions
set vop-=options
" Storing blank buffers is pointless
set ssop-=blank
" }}}
" Filetype overrides {{{
if has("linux") && (has("gui_running") || $SSH_TTY == "")
    augroup OGUIFiletypes
        au!
        
        au BufNewFile,BufRead *.png,*.jpg,*.jpeg call system('xdg-open ' .. expand('%:p'))
    augroup END
endif
augroup OFiletypeAliases
    au!

    " Compound filetype so html stuff (particularly snippets and certain
    " plugins) still work
    " See https://vi.stackexchange.com/a/4941 for the notation
    au BufNewFile,BufRead *.mustache setlocal ft=html.mustache
    au BufNewFile,BufRead *.cpp,*.hpp setlocal ft=cpp.doxygen

augroup END
" }}}
" Title management {{{
set title titlelen=50
set titlestring=%{getcwd()->fnamemodify(':t')}:\ %{expand(\"%:t\")}
" }}}
" netrw stuff {{{
if has("linux")
    " The linux default for gx is gnome-open, which doesn't seem to exist on
    " my distro. xdg-open is fairly portable, but it's borked in gVim. setsid
    " (whatever that is, didn't bother checking) seems to work around this.
    "
    " Thank you Christian Brandt: https://vi.stackexchange.com/a/5034/21251
    let g:netrw_browsex_viewer = "setsid xdg-open"
endif
" }}}
" Colorcolumn {{{
" Sets a cursorcolumn to appear at &textwidth. Most files don't have this
" configured, but the ones that do get a visible alignment thing
set colorcolumn=+0

augroup TWOverride
    au!
    " Disable the cursorcolumn in all 
    autocmd BufEnter * if &ro == 1 | exec 'setlocal colorcolumn=' | endif
    " Per convention -- though 79 and 78 are more common here, I prefer 80 for
    " helpfiles. Helpfiles are much more sensitive to alignment, so even numbers
    " are arguably better
    autocmd FileType help if &ro == 0 | exec 'setlocal textwidth=80' | endif
    " Per pep8
    autocmd FileType python setlocal textwidth=79
    " Per personal preference
    autocmd FileType cpp setlocal textwidth=120

augroup END
" }}}
" Grepping, search, and fun with quickfix {{{
if executable("rg")
    set grepprg=rg\ --vimgrep\ --smart-case
endif

nnoremap <F7> :copen<cr>
nnoremap <leader>cn :cnext<cr>
nnoremap <leader>cp :cprev<cr>
" }}}
" Utility {{{
command! Chmod :!chmod +x %
" }}}
" }}}
" Mappings {{{
" Fix copy-pasta {{{
noremap <leader>pp "0p
noremap <leader>P "0P
" }}}
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
            au!
            au CursorHoldI,CursorHold <buffer> silent update
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

    inoremap <C-Tab> <C-v><Tab>
endif
"}}}
" Vimrc {{{
if empty($MYVIMRC)
    let $MYVIMRC = "~/.vimrc"
endif
nnoremap <leader>ve :split $MYVIMRC<cr>
nnoremap <leader>vE :e $MYVIMRC<cr>
nnoremap <leader>vt :tabe $MYVIMRC<cr>
nnoremap <leader>va :split ~/.shell_aliases<cr>
nnoremap <leader>vz :split ~/.zshrc<cr>

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

" Buftab navigation
" TODO: tmap equivalents
nmap <S-F5> gt
nmap <S-F6> gT

" }}}
" LaTeX {{{
fun! TexMaps()
    nmap <buffer> <F10> :VimtexCompile<cr>
    imap <buffer> <C-l><C-i> \textit{
    vmap <buffer> <C-l><C-i> xi\textit{<esc>p

    imap <buffer> <C-l><C-b> \textbf{
    vmap <buffer> <C-l><C-b> xi\textbf{<esc>p
    if !has("gui_running")
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
" C++ helpers {{{
fun! CppMaps()
    command! -buffer -nargs=0 CppSwitch execute 'e' expand('%:r') .. (expand('%:e') == 'cpp' ? '.hpp' : '.cpp')

    nnoremap <buffer> <leader>cps :CppSwitch<CR>
endfun
" }}}
" Project helpers {{{
" CMake {{{
fun! OpenCMakeTests()
    if isdirectory("tests/")
        e tests/CMakeLists.txt
    elseif isdirectory("test/")
        e test/CMakeLists.txt
    else
        echoerr "Failed to locate test directory. Is this a project with obscure standards?"
    endif
endfun

nnoremap <leader>cmr :e CMakeLists.txt<cr>
nnoremap <leader>cmp :e src/CMakeLists.txt<cr>
nnoremap <leader>cmt :call OpenCMakeTests()<cr>
" }}}
" }}}
" Filetype maps {{{
augroup FileMaps
    au!
    autocmd FileType tex call TexMaps()
    autocmd FileType cpp call CppMaps()

    autocmd FileType fern call FernMaps()
augroup END
" }}}
" Custom movements {{{
" Delete Around Argument delete in word delete to find space
nnoremap daa diwdf<space>
" Not directly a movement, but close enough

nnoremap ø 0i
nnoremap æ ^i
" }}} 
" Utility {{{
" Copy-pasta {{{
command! -nargs=0 CopyLastCommand let @+ = @:
command! -nargs=+ -complete=command CopyCommandOutput redir @+ | <args> | redir END 

nnoremap <leader>ccp :CopyLastCommand<cr>
" }}}
" Vim management {{{
nnoremap <leader>ffs :redraw!<cr>
" }}}
" Mark helpers {{{
" Store a jumpback mark in the Z register (AKA the register I'm least likely
" to use for anything non-scripted, because it's exceedingly unlikely I'll
" _have_ to dive into )
nnoremap <leader>sp mZ
nnoremap <leader>sr 'Z
" }}}
" Uncategorized {{{

" }}}
" }}}
" }}}
" Custom functions and commands {{{
" Fancy editing {{{
command! -complete=file -nargs=1 E :e %:h/<args>
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
function! Scd(location)
    execute 'cd' a:location
    <F2>
endfunction

command! -nargs=1 -complete=dir Scd call Scd(<f-args>)
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
nnoremap <leader>odd :DeleteThis<cr>
" }}}

" Ultisnips {{{
" Preface: ultisnips is the most moody plugin on the face of the earth.
" It breaks regularly, and it breaking has severe consequences.
" So, introducing, the UltiSnips aborter.
" Removes the ultisnips directory so you don't have to suffer from half a
" million insert mode errors when trying to manually remove it from your
" .vimrc.
" Would be nice if the creators made ultisnips even vaguely stable, but they
" didn't, so here we are.
" (Funnily enough, since introducing this command, I've never used it)
command! -nargs=0 UninstallUltiSnips call delete($HOME .. "/.vim/plugged/ultisnips", "rf")
" }}}
" }}}
" gVim config {{{
if has("gui_running")
    set wak=no
    " Disable the GUI toolbars (they're noisy)
    " Note to self: there cannot be a space between the = and letter.
    " Otherwise, it thinks i.e. " m" is the option, not just "m".
    set guioptions -=m
    set guioptions +=k
    " Necessary (on Linux) to avoid a GTK bug: https://gitlab.gnome.org/GNOME/gtk/-/issues/6751
    " The dialogs still work, but cannot be interacted with using the keyboard
    set guioptions+=c

    " Force british
    language messages en_GB.UTF-8
    set langmenu=en_GB.UTF-8
    " Bells are the _worst_
    autocmd GUIEnter * set vb t_vb=
    autocmd VimEnter * set guioptions-=T


    " This mapping only works in Vim. The alleged workarounds on the wiki do
    " not work
    imap <C-BS> <C-w>
    imap <C-Del> <C-o>dw

    map <S-Insert> "+p
    imap <S-Insert> <Esc>"+p
    map <C-Insert> "+y
    imap <C-Insert> <Esc>"+y
else
    " Because some keys with esc as part of its code are mapped, the terminal
    " timeout has to be reduced. https://vi.stackexchange.com/a/24938/21251
    set ttimeoutlen=10
endif
" }}}
" WSL patches {{{
call system("uname -r | grep -q WSL")
if v:shell_error == 0
    " Necessary hack for gvim, since gvim doesn't properly strip CRLFs to LFs
    " when pasting. This likely applies elsewhere too, but I think other
    " editors are far more aggressive at fixing it automatically
    fun! s:FixWSLCopying()
        let event = v:event
        if event.regname == "*" || event.regname == "+"
            if (event.regname->stridx("\r") >= 0)
                call setreg(event.regname, event.regcontents->substitute("\r", "", "g"))
            endif
        endif
    endfun
    augroup WslPatches
        au!
        autocmd TextYankPost * call s:FixWSLCopying()
    augroup END

    " Scaling does not apply to WSL windows
    command! Small set guifont=SauceCodePro\ Nerd\ Font\ 12
    command! Large set guifont=SauceCodePro\ Nerd\ Font\ 16

    nnoremap <leader>wp :%s/\r//g<cr>
endif

" }}}
" External config {{{
" This enables system-specific configurations that don't make sense to keep in
" the .vimrc (i.e. sensitive config, or config that is system-specific (i.e.
" startify bookmarks)).
if filereadable($HOME .. "/.vim/.systemrc")
    source $HOME/.vim/.systemrc
endif
" }}}
" Paths for Vim-generated files {{{
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

if !isdirectory($HOME .. "/.vim/backup")
    call mkdir($HOME .. "/.vim/backup", "p")
endif
if !isdirectory($HOME .. "/.vim/swap")
    call mkdir($HOME .. "/.vim/swap", "p")
endif

function! ToggleVerbose()
    if !&verbose
        set verbosefile=~/.log/vim/verbose.log
        set verbose=15
    else
        set verbose=0
        set verbosefile=
    endif
endfunction
command! Debug :call ToggleVerbose()<cr>
" }}}
" vim:sw=4
