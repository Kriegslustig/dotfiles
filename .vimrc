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

execute pathogen#infect()

source ~/.vim/dragvisuals.vim

command! -nargs=* Wrap set wrap linebreak nolist

" Set to auto read when a file is changed from the outside
set autoread

set number

" Bells
set novisualbell

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pugin specific
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:javascript_plugin_jsdoc = 1

" Disable flow by default
let g:flow#enable = 0

" expand_region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

let g:deoplete#enable_at_startup = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

let g:ctrlp_map = '<leader>l'
let g:ctrlp_cmd = 'CtrlP'

" Fast saving
nmap <leader>w :w!<cr>
nmap <leader>q :wq<cr>
inoremap jk <ESC>
inoremap Jk <ESC>

" Close a buffer with ,bd
map <leader>bd :Bclose<cr>

map <leader>n :bn<cr>
map <leader>p :bp<cr>
nnoremap <C-j> 10gj
nnoremap <C-k> 10gk

map <leader>e :e<Space>
map <leader>s :vsp<cr>

" dash lookup
nmap <leader>d :Dash<cr>

" Replace word with buffer
map <leader>r "_dw"*P

" Tabs
nmap <C-t>n :tabn<cr>
nmap <C-t>p :tabp<cr>

noremap <Space> :
noremap / /\v

nnoremap <esc> :noh<return><esc>

" Moving whole blocks and lines around using dragvisuals.vim
vmap <expr> <Left> DVB_Drag('Left')
vmap <expr> <Right> DVB_Drag('Right')
vmap <expr> <Up> DVB_Drag('Up')
vmap <expr> <Down> DVB_Drag('Down')

" CtrlP
nmap <leader>j :CtrlPBuffer<cr>

" NERDTree
map <C-n> :NERDTreeToggle<CR>

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
" => Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_enable_highlighting = 1
" Disable annotations next to column numbers (slow)
let g:syntastic_enable_signs = 0
let g:syntastic_cursor_columns = 0
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint', 'flow']

let g:airline#extensions#syntastic#enabled = 0

" Local linter sypport
let g:syntastic_javascript_checkers = []

function! CheckJavaScriptLinter(filepath, linter)
  if exists('b:syntastic_checkers')
    return
  endif
  if filereadable(a:filepath)
    let b:syntastic_checkers = [a:linter]
    let {'b:syntastic_' . a:linter . '_exec'} = a:filepath
  endif
endfunction

function! SetupJavaScriptLinter()
  let l:current_folder = expand('%:p:h')
  let l:bin_folder = fnamemodify(syntastic#util#findFileInParent('package.json', l:current_folder), ':h')
  let l:bin_folder = l:bin_folder . '/node_modules/.bin/'
  call CheckJavaScriptLinter(l:bin_folder . 'standard', 'standard')
  call CheckJavaScriptLinter(l:bin_folder . 'eslint', 'eslint')
endfunction

autocmd FileType javascript call SetupJavaScriptLinter()

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

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


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

