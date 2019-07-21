"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NeoBundle Stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" NeoBundles
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }

NeoBundle 'mattn/emmet-vim'
NeoBundle 'w0rp/ale'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'robertmeta/nofrils'
NeoBundle 'mbbill/undotree'
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'vimoutliner/vimoutliner'

NeoBundle 'LucHermitte/lh-vim-lib'
NeoBundle 'LucHermitte/local_vimrc'

NeoBundle 'rust-lang/rust.vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'aklt/plantuml-syntax'

NeoBundle 'MarcWeber/vim-addon-mw-utils'
NeoBundle 'tomtom/tlib_vim'
NeoBundle 'garbas/vim-snipmate'
NeoBundle 'vim-scripts/TaskList.vim'
NeoBundle 'junegunn/fzf'
NeoBundle 'MattesGroeger/vim-bookmarks'

NeoBundleLazy 'flowtype/vim-flow', {
\ 'autoload': {
\     'filetypes': 'javascript'
\ }}

call neobundle#end()

NeoBundleCheck

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set clipboard+=unnamed

set shell=/bin/bash
let g:python_host_skip_check = 1

" Allow secure project specific configuration
set exrc
set secure

" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

command! -nargs=* Wrap set wrap linebreak nolist

" Set to auto read when a file is changed from the outside
set autoread

set number

" Bells
set novisualbell

set colorcolumn=80

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pugin specific
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:javascript_plugin_jsdoc = 1

" Disable flow by default
nmap <leader>f :FlowType<cr>

" expand_region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

let g:deoplete#enable_at_startup = 1

let g:ale_fixers = {
\  'typescript': ['prettier', 'eslint'],
\  'javascript': ['prettier', 'eslint'],
\  'css': ['stylelint'],
\}
let g:ale_fix_on_save = 0

let g:ale_linters = {
\  'javascript': ['eslint', 'flow'],
\  'typescript': ['tsserver', 'eslint'],
\}
let g:airline#extensions#ale#enabled = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

" Snipmate
let g:snipMate = get(g:, 'snipMate', {}) " Allow for vimrc re-sourcing
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['typescript'] = 'typescript,javascript'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

let g:ctrlp_map = '<leader>l'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = 'fd --type f'

" vim-bookmarks
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1
let g:bookmark_location_list = 1
let g:bookmark_disable_ctrlp = 1
nmap <leader><leader> <Plug>BookmarkToggle
nmap <leader>i <Plug>BookmarkAnnotate
nmap <leader>a <Plug>BookmarkShowAll
nmap <leader>; <Plug>BookmarkNext
nmap <leader>, <Plug>BookmarkPrev

" Fast saving
nmap <leader>W :wa<cr>
nmap <leader>w :call MkdirAndWrite()<cr>
nmap <leader>q :wq<cr>
inoremap jk <ESC>
inoremap Jk <ESC>

" Close a buffer with ,bd
map <leader>bd :Bclose<cr>

map <leader>n :bn<cr>
map <leader>p :bp<cr>
nnoremap <C-j> 10gj
nnoremap <C-k> 10gk

nmap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
nmap <leader>p :split <C-R>=expand("%:p:h") . "/" <CR>
map <leader>s :vsp<cr>

nnoremap <esc>^[ <esc>^[

" Replace word with buffer
map <leader>r "_dw"*P

" Tabs
nmap <C-t>n :tabn<cr>
nmap <C-t>p :tabp<cr>

noremap <Space> :
noremap / /\v

" Moving whole blocks and lines around using dragvisuals.vim
vmap <expr> <Left> DVB_Drag('Left')
vmap <expr> <Right> DVB_Drag('Right')
vmap <expr> <Up> DVB_Drag('Up')
vmap <expr> <Down> DVB_Drag('Down')

" CtrlP
nmap <leader>j :CtrlPBuffer<cr>

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" diffing
if &diff
  map <leader>1 :diffget LOCAL<CR>
  map <leader>2 :diffget BASE<CR>
  map <leader>3 :diffget REMOTE<CR>
endif

" ALE
nmap <leader>f :ALEFix<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*/node_modules/*,*/elm-stuff/*,*/vendor/*,*/default/config_*,*/deps/*,*/dist/*,*/typings/*,*/flow-typed/*

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Fancy search selection
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Makes search act like search in modern browsers
set incsearch

" Highlight search results
set hls

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Clipboard
set clipboard=unnamed


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax on

" Indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 1

au BufNewFile,BufRead *.tag setlocal ft=html
au BufNewFile,BufRead *.ts setlocal ft=typescript

command! Lights call Lights()
function! Lights ()
  colo nofrils-light
  hi IndentGuidesOdd  ctermbg=255
  hi IndentGuidesEven ctermbg=254
endfunction

command! Dark call Dark()
function! Dark ()
  colo nofrils-dark
  highlight LineNr ctermfg=grey
  hi IndentGuidesOdd  ctermbg=235
  hi IndentGuidesEven ctermbg=236
endfunction

" Use Unix as the standard file type
set ffs=unix,dos,mac

highlight SpellBad ctermbg=88
highlight Search ctermbg=240
highlight Search ctermbg=242
highlight SpellLocal ctermbg=NONE ctermfg=248

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
set expandtab

" Linebreak on 500 characters
set lbr

set ai "Auto indent
set si
set wrap "Wrap lines

" Set Display some characters if there are trailing spaces or tabs
set listchars=tab:~~,trail:-,nbsp:_
au BufRead,BufNewFile *.otl set listchars=tab:\ \ 

set list
set sbr=…


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

map <leader>u :call Fsucks()<cr><cr>
fu! Fsucks ()
  w!
  execute("!~/Software/nodejs/fsucks/index.js put ".bufname(''))
endfunction

command! Mkdir call Mkdir()
function! Mkdir()
  let l:dirname = system("dirname " . expand("%:p"))
  call system("mkdir -p " . l:dirname)
endfunction

function! MkdirAndWrite()
  call Mkdir()
  execute("w!")
endfunction

command! Present call Present()
function! Present ()
  execute("set nonumber")
endfunction
command! NoPresent call NoPresent()
function! NoPresent ()
  execute("set number")
endfunction

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Macros
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap m 1@
let @d = 'ko*/jkhi jkko *jkko/**jk0jA jk'
let @c = 'iconsole.log(jkea)jk'

